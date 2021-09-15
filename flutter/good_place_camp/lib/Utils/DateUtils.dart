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
  final now = DateTime.now().toUtc().add(Duration(hours: 9));
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
    return "방금 전";
  }
}

// reservation_open 규칙
// '1/2/3/4/5'
// 1 - (예약 오픈일) Y: 매년, M: 매월, W: 매주, D: 매일
// 2 - '1'에서 M의 경우에는 Day, '1'에서 W의 경우에는 요일, 그 외에는 안씀
// 3 - 시간
// 4 - (예약 오픈이 몇일 전에 열리는지) M: 매월, W: 매주
// 5 - '4'에 해당하는 날의 숫자

// "매일 (3개월 이후 자리 오픈)" => D///M/3
// "매주 일요일10시" => W/SUN/10//
// "매월 15일 14시" => M/15/14//

String getReservationOpenStr(String reservationCode) {
  final infoArgs = reservationCode.split('/');
  final openInterval = infoArgs[0];

  var text = "";

  if (openInterval == 'Y') {
    // 예약 간격이 매년일 경우
    text = "매년";
  } else if (openInterval == 'M') {
    // 예약 간격이 매월일 경우
    text = "매월";
    final openDay = infoArgs[1];
    if (openDay.isNotEmpty) {
      text += " $openDay일";

      final openHour = infoArgs[2];
      if (openHour.isNotEmpty) {
        text += " $openHour시";
      }
    }

    return text;
  } else if (openInterval == 'W') {
    // 예약 간격이 매주일 경우
    text = "매주";
    final openWeek = infoArgs[1];
    if (openWeek.isNotEmpty) {
      switch (openWeek) {
        case "MON":
          text += " 월요일";
          break;
        case "TUE":
          text += " 화요일";
          break;
        case "WED":
          text += " 수요일";
          break;
        case "THU":
          text += " 목요일";
          break;
        case "FRI":
          text += " 금요일";
          break;
        case "SAT":
          text += " 토요일";
          break;
        case "SUN":
          text += " 일요일";
          break;
        default:
          break;
      }

      final openHour = infoArgs[2];
      if (openHour.isNotEmpty) {
        text += " $openHour시";
      }
    }
  } else {
    text = "매일";
  }

  // 예약일 간격 정보
  final reservationInterval = infoArgs[3];
  if (reservationInterval.isNotEmpty) {
    final interval = infoArgs[4];
    if (reservationInterval == 'M') {
      text += " ($interval개월 이후 자리 오픈)";
    } else if (reservationInterval == 'W') {
      text += " ($interval주 후 자리 오픈)";
    }
  }

  return text;
}

List<DateTime> getReservationOpenDate(String reservationCode) {
  final infoArgs = reservationCode.split('/');
  final openInterval = infoArgs[0];

  if (openInterval == 'Y') {
    // 예약 간격이 매년일 경우
    return [];
  } else if (openInterval == 'M') {
    // 예약 간격이 매월일 경우
    final openDayStr = infoArgs[1];
    if (openDayStr.isNotEmpty) {
      final openDay = int.parse(openDayStr);
      var now = DateTime.now();
      if (now.day > openDay) {
        now = addMonths(now, 1);
      }

      final pivotDate = DateTime(now.year, now.month, openDay);
      return [0, 1].map<DateTime>((index) {
        return addMonths(pivotDate, index);
      }).toList();
    } else {
      return [];
    }
  } else if (openInterval == 'W') {
    // 예약 간격이 매주일 경우
    final openWeek = infoArgs[1];
    var weekNum = DateTime.monday;
    if (openWeek.isNotEmpty) {
      switch (openWeek) {
        case "MON":
          weekNum = DateTime.monday;
          break;
        case "TUE":
          weekNum = DateTime.tuesday;
          break;
        case "WED":
          weekNum = DateTime.wednesday;
          break;
        case "THU":
          weekNum = DateTime.thursday;
          break;
        case "FRI":
          weekNum = DateTime.friday;
          break;
        case "SAT":
          weekNum = DateTime.saturday;
          break;
        case "SUN":
          weekNum = DateTime.sunday;
          break;
        default:
          break;
      }

      final now = DateTime.now();
      var pivotDate = DateTime(now.year, now.month, now.day);
      pivotDate = pivotDate.add((Duration(days: weekNum - now.weekday)));
      if (now.isAfter(pivotDate)) {
        pivotDate = pivotDate.add(Duration(days: 7));
      }
      return [0, 1, 2, 3].map<DateTime>((index) {
        return pivotDate.add((Duration(days: 7 * index)));
      }).toList();
    }
  } else {
    return [];
  }
}
