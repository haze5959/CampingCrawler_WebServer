import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Utils/DateUtils.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';

// Model
import 'package:good_place_camp/Model/CampInfo.dart';
import 'package:good_place_camp/Model/SiteInfo.dart';
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:good_place_camp/Model/Post.dart';

// Widgets
import 'package:good_place_camp/Widget/Sheets/SiteInfoListSheet.dart';
import 'package:good_place_camp/Widget/Common/CalenderWidget.dart';

class HomeController extends CalenderInterface {
  // 사이트별 가능한 날짜 리스트
  List<SiteDateInfo> siteInfoList = List<SiteDateInfo>.empty();

  Map<DateTime, List<SiteInfo>> events = Map<DateTime, List<SiteInfo>>();

  // 해당 지역의 캠핑장 리스트
  List<CampSimpleInfo> accpetedCampInfo = <CampSimpleInfo>[];

  List<Post> noticeList = List<Post>.empty();
  List<Post> postList = List<Post>.empty();

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
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

    reload();
  }

  void reload() async {
    isLoading.value = true;
    _updateAccpetedCampInfo();
    try {
      await _updateHomeInfo();
    } on TimeoutException catch (e) {
      print(e.message);
      Get.offNamed("/error");
      return;
    }
    isLoading.value = false;
    update();
  }

  Future<void> _updateHomeInfo() async {
    // 달력정보 로드
    final bit = toAreaBit(Constants.myArea);
    final res = await ApiRepo.site.getHomeInfo(bit).timeout(TIME_OUT);
    if (!res.result) {
      showServerErrorAlert(res.msg, false);
      return;
    }

    final data = res.data!;
    events.clear();
    _updateEvents(data.camps);
    _updateHoliday(Constants.holiday);
    _updateReservationDay();

    siteInfoList = data.camps;

    // 게시물 로드
    noticeList = data.community.noticeList;
    postList = data.community.postsList;
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
        final parseDate = DateTime.parse(date);
        events[DateTime.utc(parseDate.year, parseDate.month, parseDate.day)] =
            list;
      }
    }
  }

  void _updateHoliday(Map<String, String> holiday) {
    // 공휴일 처리
    holiday.forEach((key, value) {
      holidays[DateTime.utc(
          int.parse(key.substring(0, 4)),
          int.parse(key.substring(4, 6)),
          int.parse(key.substring(6, 8)))] = [value];
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

          events[DateTime.utc(date.year, date.month, date.day)] = list;
        }
      }
    });
  }

  void _updateAccpetedCampInfo() {
    final allInfo = Constants.campInfoMap.values.toList();
    if (Constants.myArea.length == CampArea.values.length) {
      accpetedCampInfo = allInfo;
    } else {
      accpetedCampInfo.clear();
      for (final info in allInfo) {
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
    final selectedDate =
        DateTime.utc(selectDay.year, selectDay.month, selectDay.day);

    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: Get.context!,
        builder: (context) =>
            SiteInfoListSheet(selectedDate.obs, holidays, events));
  }
}
