import 'dart:math';

DateTime addMonths(DateTime from, int months) {
  final r = months % 12;
  final q = (months - r) ~/ 12;
  var newYear = from.year + q;
  var newMonth = from.month + r;
  if (newMonth > 12) {
    newYear++;
    newMonth -= 12;
  }
  final newDay = min(from.day, _daysInMonth(newYear, newMonth));
  if (from.isUtc) {
    return DateTime.utc(newYear, newMonth, newDay, from.hour, from.minute,
        from.second, from.millisecond, from.microsecond);
  } else {
    return DateTime(newYear, newMonth, newDay, from.hour, from.minute,
        from.second, from.millisecond, from.microsecond);
  }
}

int _daysInMonth(int year, int month) {
  var result = _daysInMonthArray[month];
  if (month == 2 && _isLeapYear(year)) result++;
  return result;
}

const _daysInMonthArray = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

bool _isLeapYear(int year) =>
    (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
