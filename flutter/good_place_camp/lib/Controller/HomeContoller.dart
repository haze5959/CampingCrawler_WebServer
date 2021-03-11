import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Model/CampInfo.dart';
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

  Map<String, CampInfo> accpetedCampInfo = Map<String, CampInfo>();

  RxList<Post> postList = RxList<Post>.empty();

  List<CalendarController> calendarControllerList = [
    CalendarController(),
    CalendarController(),
    CalendarController(),
    CalendarController()
  ];

  DateTime selectedDay = DateTime.now();

  RxBool isLoading = true.obs;

  BuildContext context;

  @override
  void onReady() {
    super.onReady();
    initData();
  }

  void initData() async {
    Constants.selectedArea = await getCampAreaData();
    final result = await repo.getAllSiteJson();
    if (result.hasError) {
      showOneBtnAlert(result.statusText, "재시도", reload);
      return;
    }

    Constants.campInfo = result.body;

    reload();
    // BoardType.
    // BoardModel();
    // Post(PostType)
    // PostModel(PostType.notice, "", "");
    // final postList = [];

    // final testItem = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    //     .map((key) => Post(
    //           "타이틀$key",
    //           "바디들",
    //           "으허허헝",
    //         ))
    //     .toList();
    // postList.assignAll(testItem);
  }

  void reload() async {
    isLoading.value = true;
    final result = await repo.getSiteInfo(Constants.selectedArea);
    if (result.hasError) {
      showOneBtnAlert(result.statusText, "재시도", reload);
      return;
    }

    var siteInfo = result.body;
    updateEvents(siteInfo);
    siteInfoList = siteInfo;

    updateAccpetedCampInfo();

    update();

    isLoading.value = false;
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
    if (Constants.selectedArea.isEmpty) {
      accpetedCampInfo = Map.from(Constants.campInfo);
    } else {
      accpetedCampInfo.clear();
      for (final key in Constants.campInfo.keys) {
        final info = Constants.campInfo[key];
        if (Constants.selectedArea.contains(info.area)) {
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

      Future.delayed(const Duration(milliseconds: 500), () {
        showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return BottomSheetContent(date: day, infoList: siteInfoList);
          },
        );
      });
    }
  }

  void showOneBtnAlert(String msg, String btnText, Function() confirmAction) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              msg,
            ),
            actions: [
              TextButton(
                child: Text(btnText),
                onPressed: () {
                  confirmAction();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
