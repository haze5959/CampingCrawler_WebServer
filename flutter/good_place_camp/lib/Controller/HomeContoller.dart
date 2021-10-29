import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Utils/DateUtils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:good_place_camp/Model/CampInfo.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Repository
import 'package:good_place_camp/Repository/SiteRepository.dart';
import 'package:good_place_camp/Repository/PostsRepository.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:good_place_camp/Model/Post.dart';

// Widgets
import 'package:good_place_camp/Widget/Sheets/BottomSheetContent.dart';

class HomeController extends GetxController {
  final SiteRepository repo = SiteRepository();
  final PostsRepository postRepo = PostsRepository();

  // 사이트별 가능한 날짜 리스트
  RxList<SiteInfo> siteInfoList = RxList<SiteInfo>.empty();

  Map<DateTime, List<SiteInfo>> events = Map<DateTime, List<SiteInfo>>();
  Map<DateTime, List<String>> holidays = Map<DateTime, List<String>>();

  // 해당 지역의 캠핑장 리스트
  Map<String, CampSimpleInfo> accpetedCampInfo = Map<String, CampSimpleInfo>();

  RxList<Post> noticeList = RxList<Post>.empty();
  RxList<Post> postList = RxList<Post>.empty();

  List<CalendarController> calendarControllerList = [
    CalendarController(),
    CalendarController(),
    CalendarController(),
    CalendarController()
  ];

  RxBool isLoading = true.obs;

  BuildContext context;

  @override
  void onReady() {
    super.onReady();
    initData();

    Constants.auth.userChanges().listen((user) {
      if (user != null) {
        Constants.user.value.login(user);
      }
    });
  }

  void initData() async {
    print("홈 데이터 로드");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final areaBit = prefs.getInt(MY_AREA_BIT_KEY) ?? 0;
    final myArea = fromBit(areaBit);
    Constants.myArea = myArea.obs;

    final result = await repo.getAllSiteJson();
    if (result.hasError) {
      showOneBtnAlert(context, "서버가 불안정합니다. 잠시 후에 다시 시도해주세요.", "재시도", initData);
      return;
    } else if (!result.body.result) {
      showOneBtnAlert(context, result.body.msg, "재시도", initData);
      return;
    }

    Constants.campSimpleInfo = CampSimpleInfo.fromJsonArr(result.body.data);

    reload();
  }

  void reload() async {
    isLoading.value = true;
    _updateAccpetedCampInfo();
    await updateCampSiteAvailDates();
    await updatePostList();
    isLoading.value = false;
    update();
  }

  Future<void> updatePostList() async {
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

  void _updateEvents(List<SiteDateInfo> infoList) {
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

  void _updateHoliday(Map<String, String> holiday) {
    // 공휴일 처리
    holiday.forEach((key, value) {
      holidays[DateTime.parse(key)] = [value];
    });
  }

  void _updateReservationDay() {
    // 예약시작일 처리
    accpetedCampInfo.forEach((key, value) {
      final reservationDateList = getReservationOpenDate(value.reservationOpen);
      if (reservationDateList.length > 0) {
        for (final date in reservationDateList) {
          final info = ReservationInfo(key, value.reservationOpen);
          var list = events[date];
          if (list == null) {
            list = [info];
          } else {
            list.add(info);
          }

          events[date] = list;
        }
      }
    });
  }

  Future<void> updateCampSiteAvailDates() async {
    final result = await repo.getSiteInfo(Constants.myArea);
    if (result.hasError) {
      showOneBtnAlert(context, result.statusText, "재시도", reload);
      return;
    } else if (!result.body.result) {
      showOneBtnAlert(context, result.body.msg, "재시도", reload);
      return;
    }

    final siteInfo = SiteDateInfo.fromJsonArr(result.body.data["camps"]);
    final holiday = Map<String, String>.from(result.body.data["holiday"]);
    events.clear();
    _updateEvents(siteInfo);
    _updateHoliday(holiday);
    _updateReservationDay();

    siteInfoList.value = siteInfo;
  }

  void _updateAccpetedCampInfo() {
    if (Constants.myArea.isEmpty) {
      accpetedCampInfo = Map.from(Constants.campSimpleInfo);
    } else {
      accpetedCampInfo.clear();
      for (final key in Constants.campSimpleInfo.keys) {
        final info = Constants.campSimpleInfo[key];
        if (Constants.myArea.contains(info.area)) {
          accpetedCampInfo[key] = info;
        }
      }
    }
  }

  void onDaySelected(DateTime day, List _, List __) {
    final selectedDate = DateTime(day.year, day.month, day.day);

    if (GetPlatform.isWeb) {
      Future.delayed(
          const Duration(milliseconds: 1),
          () => showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (context) =>
                  BottomSheetContent(selectedDate.obs, events, holidays)));
    } else {
      showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          builder: (context) =>
              BottomSheetContent(selectedDate.obs, events, holidays));
    }
  }
}
