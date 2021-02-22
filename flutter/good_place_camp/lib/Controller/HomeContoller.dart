import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:good_place_camp/Constants.dart';

// Repository
import 'package:good_place_camp/Repository/SiteRepository.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:good_place_camp/Model/Post.dart';

// Widgets
import 'package:good_place_camp/Widget/Sheets/BottomSheetContent.dart';

class HomeController extends GetxController {
  SiteRepository repo = SiteRepository();

  List<SiteInfo> siteInfoList = <SiteInfo>[];
  Map<DateTime, List<SiteInfo>> events = Map<DateTime, List<SiteInfo>>();

  Map<String, Map<String, Object>> accpetedCampInfo =
      Map<String, Map<String, Object>>();

  RxList<Post> postList = RxList<Post>.empty();

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
    initData();
  }

  void initData() async {
    SELECTED_AREA = await getCampAreaData();
    reload();

    final testItem = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        .map((key) => Post(
              "타이틀$key",
              "바디들",
              "으허허헝",
            ))
        .toList();
    postList.assignAll(testItem);
  }

  void reload() async {
    var result = await repo.getSiteInfo(SELECTED_AREA);
    var siteInfo = result.body;
    updateEvents(siteInfo);
    siteInfoList = siteInfo;

    updateAccpetedCampInfo();

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

  void updateAccpetedCampInfo() {
    if (SELECTED_AREA.isEmpty) {
      accpetedCampInfo = Map.from(CAMP_INFO);
    } else {
      accpetedCampInfo.clear();
      for (final key in CAMP_INFO.keys) {
        final info = CAMP_INFO[key];
        if (SELECTED_AREA.contains(info["area"])) {
          accpetedCampInfo[key] = info;
        }
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
