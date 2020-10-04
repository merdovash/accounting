import 'dart:math';

import 'package:accounting/registry/registry_item.dart';
import 'package:decimal/decimal.dart';
import 'package:timezone/timezone.dart';

enum Direction{
  UP,
  DOWN,
}

abstract class IRegistry {
  List<PayItem> load(TZDateTime startDate, TZDateTime endDate);
}

class RegistryStub extends IRegistry {
  int pos = 0;
  List<PayItem> items = new List();
  Map<DateTime, PayItem> dates = new Map();

  @override
  List<PayItem> load(TZDateTime startDate, TZDateTime endDate) {
    var interval = endDate.difference(startDate);
    for (var i = 1; i< interval.inDays; i++) {
      var date = DateTime(2020, startDate.month, startDate.day + i);
      if (dates.containsKey(date)) continue;
      var item = PayItem()
        ..category = "Стол"
        ..date = date
        ..paySum = Decimal.parse((Random().nextInt(10000) - 5000).toString())
        ..index = items.length;
      dates[date] = item;
      items.add(item);
    }
    return items;
  }
}