import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

// Repository
import 'package:good_place_camp/Repository/SiteRepository.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

// Widgets
import 'package:good_place_camp/Widget/Sheets/BottomSheetContent.dart';

class HomeController extends GetxController {
  SiteRepository repo = SiteRepository();

  List<SiteInfo> siteInfoList = <SiteInfo>[];
  Map<DateTime, List<SiteInfo>> events = Map<DateTime, List<SiteInfo>>();

  List<CalendarController> calendarControllerList = [
    CalendarController(),
    CalendarController(),
    CalendarController(),
    CalendarController()
  ];
  DateTime selectedDay = DateTime.now();

  BuildContext context;

  @override
  void onReady() {
    super.onReady();
    reload();
  }

  void reload() async {
    var result = await repo.getAllSiteInfo();
    var siteInfo = result.body;
    updateEvents(siteInfo);
    siteInfoList = siteInfo;
    update();
  }

  void updateEvents(List<SiteInfo> infoList) {
    events.clear();

    for (var info in infoList) {
      for (var date in info.availDates) {
        var list = events[DateTime.parse(date)];
        if (list == null) {
          list = [info];
        } else {
          list.add(info);
        }

        events[DateTime.parse(date)] = list;
      }
    }
  }

  void onDaySelected(DateTime day, List events, List holidays) {
    selectedDay = day;
    update();

    if (events.length > 0) {
      final List<SiteInfo> siteInfoList = events;

      showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return BottomSheetContent(date: day, infoList: siteInfoList);
        },
      );
    }
  }
}
