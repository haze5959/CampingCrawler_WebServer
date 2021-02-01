import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class CalenderWidget extends StatelessWidget {
  final HomeController c = Get.find();

  @override
  Widget build(context) {
    return TableCalendar(
      locale: Localizations.localeOf(context).languageCode,
      calendarController: c.calendarController,
      events: c.events,
      availableGestures: AvailableGestures.all,
      onDaySelected: c.onDaySelected,
      // headerVisible: false,
    );
  }
}

// 참고
// https://velog.io/@adbr/flutter-tablecalendar-builders-example

// https://stackoverflow.com/questions/64976106/how-to-set-the-locale-property-to-tablecalendar-widget