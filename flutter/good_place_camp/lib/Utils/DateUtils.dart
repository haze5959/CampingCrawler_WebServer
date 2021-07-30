import 'dart:math';
import 'package:intl/intl.dart';

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

String remainTime(String dateStr) {
  final date = _convertServerDate(dateStr);
  return getRemainTime(date);
}

DateTime _convertServerDate(String dateStr) {
  return DateFormat('yyyy/M/d hh:mm').parse(dateStr);
}

String getRemainTime(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);
  if (diff.inDays > 365) {
    final interval = (diff.inDays / 365).round();
    return "$interval년 전";
  } else if (diff.inDays > 30) {
    final interval = (diff.inDays / 30).round();
    return "$interval달 전";
  } else if (diff.inDays > 7) {
    final interval = (diff.inDays / 7).round();
    return "$interval주 전";
  } else if (diff.inDays > 0) {
    return "${diff.inDays}일 전";
  } else if (diff.inHours > 0) {
    return "${diff.inHours}시간 전";
  } else if (diff.inMinutes > 0) {
    return "${diff.inMinutes}분 전";
  } else {
    return "${diff.inSeconds}초 전";
  }
}
