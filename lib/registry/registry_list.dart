import 'dart:async';
import 'dart:math';

import 'package:accounting/database/database.dart';
import 'package:accounting/registry/registry_item.dart';
import 'package:accounting/tools/types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:accounting/tools/date.dart';

class RegistryList extends StatefulWidget {
  @override
  State<StatefulWidget> createState()  => _RegistryList();

}

class _RegistryList extends State<RegistryList> {
  late final Stream streamItems;
  late final StreamController itemsController;

  late List<PayItem> items;
  final DateTime interval = new DateTime(1970, 3);

  late DateTime startLoadedDate;
  late DateTime endLoadedDate;

  bool alreadyLoading = false;

  double extentAfter = 1;
  _RegistryList() {
    itemsController = new StreamController<List<PayItem>>();
    streamItems = itemsController.stream;

    startLoadedDate = DateTime.now();
    endLoadedDate = DateTime.now();
    items = [];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNext();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: StreamBuilder(
        stream: streamItems,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            loadNext();
            return CircularProgressIndicator();
          }
          return NotificationListener<ScrollNotification>(
            child: ListView(
              children: buildWidgetsFromItems(saveNewItems(safe_cast<List<PayItem>>(snapshot.data, [])))
                  .toList(growable: false),
              controller: ScrollController(),
            ),
            onNotification: (ScrollNotification notification) {
              if (notification.metrics.extentAfter <= extentAfter) {
                setState(() {
                  loadNext();
                });
              }
              return false;
            },
          );
        },
      )
    );
  }

  loadNext() async {
    var lastDate = addDates(endLoadedDate, interval);
    var result = await DatabaseConnection()
        .rawQuery(
        '''
          select * 
          from "Pay" 
          where
             "date" >= ?
             and "date" < ?
          order by
            "date" asc
        ''',
        [
          endLoadedDate,
          lastDate,
        ]
    ).then((List<Map<String, dynamic>> el) {
      endLoadedDate = lastDate;
      return el.map(PayItem.fromJson).toList();
    });
    itemsController.add(result);
  }

  List<PayItem> saveNewItems(List<PayItem> items) {
    this.items.addAll(items);
    return this.items;
  }

  Iterable<Widget> buildWidgetsFromItems(List<PayItem>? items) sync* {
    DateTime currentDate = startLoadedDate;
    DateTime lastDate;
    Iterator<PayItem> iterator;
    bool hasNext;
    PayItem? current;
    if (items != null && items.length > 0) {
      lastDate = max(endLoadedDate, items.last.date);
      iterator = items.iterator;
      hasNext = iterator.moveNext();
      current  = iterator.current;
    } else {
      lastDate = endLoadedDate;
      iterator = <PayItem>[].iterator;
      hasNext = false;
      current = null;
    }


    while (currentDate.millisecondsSinceEpoch < lastDate.millisecondsSinceEpoch) {
      if (currentDate.day == 1) {
        if (currentDate.month == 1) {
          yield Text('${currentDate.year} год');
        }
        yield Text('Месяц ${currentDate.month}');
      }
      yield Divider();
      yield Text(currentDate.day.toString());
      while (hasNext && current!=null && sameDay(currentDate, current.date)) {
        yield ListTile(
          title: Text(current.paySum.toString()),
        );
        hasNext = iterator.moveNext();
        if (hasNext) current = iterator.current;
      }

      currentDate = addDay(currentDate);
    }
  }
}