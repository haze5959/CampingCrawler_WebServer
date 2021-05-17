import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Model/CampInfo.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Repository
import 'package:good_place_camp/Repository/SiteRepository.dart';
import 'package:good_place_camp/Repository/PostsRepository.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:good_place_camp/Model/Post.dart';
import 'package:good_place_camp/Model/CampUser.dart';

// Widgets
import 'package:good_place_camp/Widget/Sheets/BottomSheetContent.dart';

class HomeController extends GetxController {
  final SiteRepository repo = SiteRepository();
  final PostsRepository postRepo = PostsRepository();

  List<SiteInfo> siteInfoList = <SiteInfo>[];
  Map<DateTime, List<SiteInfo>> events = Map<DateTime, List<SiteInfo>>();

  Map<String, CampInfo> accpetedCampInfo = Map<String, CampInfo>();

  RxList<Post> noticeList = RxList<Post>.empty();
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

    Constants.auth.authStateChanges().listen((user) {
      if (user != null) {
        initData();
      }
    });
  }

  void initData() async {
    print("홈 데이터 로드");
    final user = Constants.auth.currentUser;
    if (user != null) {
      await Constants.user.value.login(user);
    }

    final result = await repo.getAllSiteJson();
    if (result.hasError) {
      showOneBtnAlert(context, result.statusText, "재시도", reload);
      return;
    } else if (!result.body.result) {
      showOneBtnAlert(context, result.body.msg, "재시도", reload);
      return;
    }

    Constants.campInfo = CampInfo.fromJsonArr(result.body.data);

    reload();
  }

  void reload() async {
    isLoading.value = true;
    final result = await repo.getSiteInfo(Constants.user.value.info.myArea);
    if (result.hasError) {
      showOneBtnAlert(context, result.statusText, "재시도", reload);
      return;
    } else if (!result.body.result) {
      showOneBtnAlert(context, result.body.msg, "재시도", reload);
      return;
    }

    var siteInfo = SiteInfo.fromJsonArr(result.body.data);
    updateEvents(siteInfo);
    siteInfoList = siteInfo;

    updateAccpetedCampInfo();
    updatePostList();
    isLoading.value = false;
    update();
  }

  void updatePostList() async {
    // 게시물 로드
    final postResult = await postRepo.getFirstPagePostsList();
    if (postResult.hasError) {
      showOneBtnAlert(context, postResult.statusText, "재시도", reload);
      return;
    } else if (!postResult.body.result) {
      showOneBtnAlert(context, postResult.body.msg, "재시도", reload);
      return;
    }

    final postJson = Post.fromJsonToHomePosts(postResult.body.data);
    noticeList.assignAll(postJson["notice"]);
    postList.assignAll(postJson["posts"]);
  }

  void updateEvents(List<SiteInfo> infoList) {
    events.clear();

    for (var info in infoList) {
      for (var date in info.availDates) {
        if (date.isEmpty) {
          break;
        }

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
    if (Constants.user.value.info.myArea.isEmpty) {
      accpetedCampInfo = Map.from(Constants.campInfo);
    } else {
      accpetedCampInfo.clear();
      for (final key in Constants.campInfo.keys) {
        final info = Constants.campInfo[key];
        if (Constants.user.value.info.myArea.contains(info.area)) {
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
}
