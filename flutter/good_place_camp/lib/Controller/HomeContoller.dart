import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Utils/DateUtils.dart';
import 'package:good_place_camp/Model/CampInfo.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:good_place_camp/Model/Post.dart';

// Widgets
import 'package:good_place_camp/Widget/Sheets/BottomSheetContent.dart';

class HomeController extends GetxController {
  // 사이트별 가능한 날짜 리스트
  RxList<SiteDateInfo> siteInfoList = RxList<SiteDateInfo>.empty();

  Map<DateTime, List<SiteInfo>> events = Map<DateTime, List<SiteInfo>>();
  Map<DateTime, List<String>> holidays = Map<DateTime, List<String>>();

  List<CampSimpleInfo> allCampInfo = <CampSimpleInfo>[];
  // 해당 지역의 캠핑장 리스트
  List<CampSimpleInfo> accpetedCampInfo = <CampSimpleInfo>[];

  RxList<Post> noticeList = RxList<Post>.empty();
  RxList<Post> postList = RxList<Post>.empty();

  RxBool isLoading = true.obs;

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

    final res = await ApiRepo.site.getAllSiteJson();
    final data = res.data;
    if (!res.result) {
      showOneBtnAlert(res.msg, "confirm".tr(), () {});
      return;
    } else if (data == null) {
      print("reloadInfo result fail - " + res.msg);
      showOneBtnAlert("server_error".tr(args: [res.msg]), "confirm".tr(), () {});
      return;
    }

    allCampInfo = data;
    Constants.campInfoMap = toCampInfoMap(data);

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
    final res = await ApiRepo.posts.getHomeInfo();
    final data = res.data;
    if (!res.result) {
      showOneBtnAlert(res.msg, "confirm".tr(), () {});
      return;
    } else if (data == null) {
      print("reloadInfo result fail - " + res.msg);
      showOneBtnAlert("server_error".tr(args: [res.msg]), "confirm".tr(), () {});
      return;
    }

    noticeList.value = data.noticeList;
    postList.value = data.postList;
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
    accpetedCampInfo.forEach((info) {
      final reservationDateList = getReservationOpenDate(info.reservationOpen);
      if (reservationDateList.length > 0) {
        for (final date in reservationDateList) {
          final reservationInfo =
              ReservationInfo(info.key, info.reservationOpen);
          var list = events[date];
          if (list == null) {
            list = [reservationInfo];
          } else {
            list.add(reservationInfo);
          }

          events[date] = list;
        }
      }
    });
  }

  Future<void> updateCampSiteAvailDates() async {
    final res = await ApiRepo.site.getSiteInfoWithArea(Constants.myArea);
    final data = res.data;
    if (!res.result) {
      showOneBtnAlert(res.msg, "confirm".tr(), () {});
      return;
    } else if (data == null) {
      print("reloadInfo result fail - " + res.msg);
      showOneBtnAlert("server_error".tr(args: [res.msg]), "confirm".tr(), () {});
      return;
    }

    events.clear();
    _updateEvents(data.sites);
    _updateHoliday(data.holiday);
    _updateReservationDay();

    siteInfoList.value = data.sites;
  }

  void _updateAccpetedCampInfo() {
    if (Constants.myArea.isEmpty) {
      accpetedCampInfo = allCampInfo;
    } else {
      accpetedCampInfo.clear();
      for (final info in allCampInfo) {
        if (Constants.myArea.contains(fromAreaInt(info.areaBit))) {
          accpetedCampInfo.add(info);
        }
      }
    }
  }

  List<SiteInfo> getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void onDaySelected(DateTime selectDay, DateTime _) {
    final selectedDate = DateTime(selectDay.year, selectDay.month, selectDay.day);

    if (GetPlatform.isWeb) {
      Future.delayed(
          const Duration(milliseconds: 1),
          () => showModalBottomSheet<void>(
              isScrollControlled: true,
              context: Get.context!,
              builder: (context) =>
                  BottomSheetContent(selectedDate.obs, events, holidays)));
    } else {
      showModalBottomSheet<void>(
          isScrollControlled: true,
          context: Get.context!,
          builder: (context) =>
              BottomSheetContent(selectedDate.obs, events, holidays));
    }
  }
}
