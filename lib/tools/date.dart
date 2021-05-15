
DateTime max(DateTime a, DateTime b) {
  if (a.millisecondsSinceEpoch > b.millisecondsSinceEpoch) return a;
  return b;
}

bool sameDay(DateTime day, DateTime date) {
  return day.year == date.year && day.month == date.month && day.day == date.day;
}

DateTime addDay(DateTime date) {
  return DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch + 60*60*24*1000);
}

DateTime addDates(DateTime date, DateTime interval) {
  return DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch + interval.millisecondsSinceEpoch);
}

int dateCmp(DateTime a, DateTime b) {
  return a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
}