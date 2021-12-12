import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';
import 'package:good_place_camp/Model/CampInfo.dart';

class CampDetailContoller extends GetxController {
  final String siteName;

  CampDetailContoller({required this.siteName}) {
    reload();
  }

  CampInfo? campInfo;
  SiteDateInfo? siteInfo;

  Rx<bool> isFavorite = Rx<bool>(false);
  RxString selectedSiteInfo = "".obs;

  bool isLoading = true;

  Map<DateTime, List<String>> events = Map<DateTime, List<String>>();
  Map<DateTime, List<String>> holidays = Map<DateTime, List<String>>();

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
      events[DateTime.utc(parseDate.year, parseDate.month, parseDate.day)] = [
        availSiteInfo
      ];
    }

    // 공휴일 처리
    holiday.forEach((key, value) {
      holidays[DateTime.parse(key)] = [value];
    });
  }

  bool _checkFavorite() {
    return Constants.user.value.info.favoriteList?.contains(siteName) ?? false;
  }

  void onClickFavorite() async {
    final user = Constants.user.value.firebaseUser;
    if (user == null) {
      showRequiredLoginAlert();
      return;
    }

    if (Constants.user.value.isLogin) {
      if (_checkFavorite()) {
        // 즐겨찾기 삭제 api
        final idToken = await user.getIdToken();
        final res =
            await ApiRepo.user.deleteUserFavoriteList(idToken, siteName);
        if (!res.result) {
          showServerErrorAlert(res.msg, false);
          return;
        }

        Constants.user.value.info.favoriteList?.remove(siteName);
        showOneBtnAlert("favorite_delete".tr(), "확인", () {
          isFavorite(false);
        });
      } else {
        // 즐겨찾기 추가 api
        final idToken = await user.getIdToken();
        final res = await ApiRepo.user.postUserFavoriteList(idToken, siteName);
        if (!res.result) {
          showServerErrorAlert(res.msg, false);
          return;
        }

        Constants.user.value.info.favoriteList?.add(siteName);
        showOneBtnAlert("favorite_add".tr(), "confirm".tr(), () {
          isFavorite(true);
        });
      }
    } else {
      showRequiredLoginAlert();
    }
  }

  List<String> getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void onDaySelected(DateTime selectDay, DateTime _) {
    if (siteInfo == null) {
      selectedSiteInfo.value = "";
      return;
    }

    final info = events[selectDay]?[0];

    if (info != null && info.isEmpty) {
      selectedSiteInfo.value = "camp_detail_no_detail".tr(namedArgs: {
        'month': selectDay.month.toString(),
        'day': selectDay.day.toString()
      });
    } else {
      selectedSiteInfo.value = "camp_detail".tr(namedArgs: {
        'month': selectDay.month.toString(),
        'day': selectDay.day.toString(),
        'info': info ?? ""
      });
    }
  }
}
