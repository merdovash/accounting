import 'dart:collection';
import 'dart:math';

import 'package:accounting/database/database.dart';
import 'file:///C:/self/AndroidStudioProjects/accounting/lib/database/pay_item.dart';
import 'package:decimal/decimal.dart';

enum Direction{
  UP,
  DOWN,
}

abstract class IRegistry {
  List<PayItem> load(DateTime startDate, DateTime endDate);
  dispose();
}

class RegistryStub extends IRegistry {
  int pos = 0;
  List<PayItem> items = [];
  Map<DateTime, PayItem> dates = new Map();

  @override
  List<PayItem> load(DateTime startDate, DateTime endDate) {
    var interval = endDate.difference(startDate);
    for (var i = 1; i< interval.inDays; i++) {
      var date = DateTime(2020, startDate.month, startDate.day + i);
      if (dates.containsKey(date)) continue;
      var item = PayItem(
        id:items.length,
        date: date,
        paySum: Decimal.parse((Random().nextInt(10000) - 5000).toString()),
      );
      dates[date] = item;
      items.add(item);
    }
    return items;
  }

  @override
  dispose() {
    // TODO: implement dispose
    return;
  }
}

class SqliteDataRegistry extends IRegistry {
  late Set<PayItem> items;

  late DatabaseConnection connection;
  SqliteDataRegistry() {
    connection = DatabaseConnection();
    items = HashSet();
  }

  void dispose() {
    connection.dispose();
  }

  @override
  List<PayItem> load(DateTime startDate, DateTime endDate) {
    List<String> args = <String>[];
    args.add(startDate.toIso8601String());
    args.add(endDate.toIso8601String());
    if (items.length > 0) {
      args.add(items.map((e) => e.id)
        .toList()
        .toString()
        .replaceAll("[", "(")
        .replaceAll(']', ")"));
    }
    connection.rawQuery('''
      select * 
      from "Pay" 
      where 
        "date" between ? and ?
        ${items.length > 0 ? 'and "id" not in ?': ''}
        ''', args
    ).then((res) {
      items.addAll(res.map((e) {
        return PayItem(
            id: e['id'],
            date: DateTime.parse(e['date']),
            paySum: Decimal.fromInt(e['paySum']),
        );
      }));
    });
    return items.toList();
  }

}