import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';
import 'package:good_place_camp/Utils/DateUtils.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';
import 'package:good_place_camp/Model/CampInfo.dart';

// Widgets
import 'package:good_place_camp/Widget/CalenderWidget.dart';

class CampDetailContoller extends CalenderInterface {
  final String siteName;

  CampInfo? campInfo;
  SiteDateInfo? siteInfo;

  Rx<bool> isFavorite = Rx<bool>(false);

  bool isLoading = true;

  Map<DateTime, List<SiteInfo>> events = Map<DateTime, List<SiteInfo>>();

  CampDetailContoller({required this.siteName});

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  void reload() async {
    final res = await ApiRepo.site.getSiteInfo(siteName);
    if (!res.result) {
      showServerErrorAlert(res.msg, true);
      return;
    }

    final data = res.data!;
    siteInfo = data.camp;
    campInfo = data.info;
    _updateEvents(data.camp, data.holiday);
    isFavorite(_checkFavorite());
    isLoading = false;
    update();
  }

  void launchHomepageURL() async {
    final url = campInfo?.homepageUrl ?? "";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchReservationURL() async {
    final url = campInfo?.reservationUrl ?? "";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchMap() async {
    final url =
        "http://map.naver.com/?zoom=6&query=${Uri.encodeComponent(campInfo?.addr ?? "")}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void callPhoneNum() async {
    launch("tel://${campInfo?.phone ?? ""}");
  }

  void _updateEvents(SiteDateInfo info, Map<String, String> holiday) {
    events.clear();

    for (var dateInfo in info.availDates) {
      if (dateInfo.isEmpty) {
        break;
      }

      final dateInfoArr = dateInfo.split(':');
      final availDate = dateInfoArr[0];
      final availSiteInfo = dateInfoArr[1];
      final parseDate = DateTime.parse(availDate);

      final info = SiteDateInfo(availSiteInfo, [""], "");
      events[DateTime.utc(parseDate.year, parseDate.month, parseDate.day)] = [
        info
      ];
    }

    // 예약시작일 처리
    final reservationOpenCode = campInfo?.reservationOpen;
    if (reservationOpenCode != null) {
      final reservationDateList = getReservationOpenDate(reservationOpenCode);
      if (reservationDateList.length > 0) {
        for (final date in reservationDateList) {
          final reservationInfo =
              ReservationInfo(siteName, reservationOpenCode);
          var list = events[date];
          if (list == null) {
            list = [reservationInfo];
          } else {
            list.add(reservationInfo);
          }

          events[DateTime.utc(date.year, date.month, date.day)] = list;
        }
      }
    }

    // 공휴일 처리
    holiday.forEach((key, value) {
      final parseDate = DateTime.parse(key);
      holidays[DateTime.utc(parseDate.year, parseDate.month, parseDate.day)] = [
        value
      ];
    });
  }

  bool _checkFavorite() {
    return Constants.user.value.info.favoriteList?.contains(siteName) ?? false;
  }

  void onClickFavorite() async {
    final token = await Constants.user.value.getToken();
    if (token == null) {
      showRequiredLoginAlert();
      return;
    }

    if (_checkFavorite()) {
      // 즐겨찾기 삭제 api
      final res = await ApiRepo.user.deleteUserFavoriteList(token, siteName);
      if (!res.result) {
        showServerErrorAlert(res.msg, false);
        return;
      }

      Constants.user.value.info.favoriteList?.remove(siteName);
      showOneBtnAlert("favorite_delete".tr, "확인", () {
        isFavorite(false);
      });
    } else {
      // 즐겨찾기 추가 api
      final res = await ApiRepo.user.postUserFavoriteList(token, siteName);
      if (!res.result) {
        showServerErrorAlert(res.msg, false);
        return;
      }

      Constants.user.value.info.favoriteList?.add(siteName);
      showOneBtnAlert("favorite_add".tr, "confirm".tr, () {
        isFavorite(true);
      });
    }
  }

  List<SiteInfo> getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void onDaySelected(DateTime selectDay, DateTime _) {
    if (siteInfo == null) {
      return;
    }

    final info = events[selectDay]?[0];

    switch (info.runtimeType) {
      case SiteDateInfo:
        if (info != null && info.site.isEmpty) {
          "camp_detail_no_detail".trParams({
            'month': selectDay.month.toString(),
            'day': selectDay.day.toString()
          });
        } else {
          "camp_detail".trParams({
            'month': selectDay.month.toString(),
            'day': selectDay.day.toString(),
            'info': info!.site
          });
        }
        break;
      case ReservationInfo:
        break;
    }

    // TODO: !!!
    // final selectedDate =
    //     DateTime.utc(selectDay.year, selectDay.month, selectDay.day);

    // showModalBottomSheet<void>(
    //     isScrollControlled: true,
    //     context: Get.context!,
    //     builder: (context) =>
    //         SiteDetailListSheet(selectedDate.obs, holidays, events));
  }
}
