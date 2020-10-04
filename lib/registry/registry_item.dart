import 'package:decimal/decimal.dart';
import 'package:sliver_calendar/sliver_calendar.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tzl;

class PayItem extends CalendarEvent {
  Decimal paySum;
  String category;

  DateTime _date;
  TZDateTime _tzDate;
  DateTime get date => _date;
  set date(value) {
    _date = value;
    _tzDate = TZDateTime.from(date, getLocation('Europe/Moscow'));
  }
  TZDateTime get instant => _tzDate;
  TZDateTime get instantEnd => _tzDate;
}