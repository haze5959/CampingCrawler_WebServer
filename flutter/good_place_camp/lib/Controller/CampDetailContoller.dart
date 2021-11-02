import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Repository
import 'package:good_place_camp/Repository/SiteRepository.dart';
import 'package:good_place_camp/Repository/UserRepository.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';
import 'package:good_place_camp/Model/CampInfo.dart';

class CampDetailContoller extends GetxController {
  final String siteName;

  CampDetailContoller({this.siteName}) {
    reload();
  }

  final SiteRepository repo = SiteRepository();
  final UserRepository userRepo = UserRepository();

  CampInfo campInfo;
  SiteDateInfo siteInfo;

  Rx<bool> isFavorite = Rx<bool>(false);
  RxString selectedSiteInfo = "".obs;

  RxBool isLoading = true.obs;

  Map<DateTime, List<String>> events = Map<DateTime, List<String>>();
  Map<DateTime, List<String>> holidays = Map<DateTime, List<String>>();

  void reload() async {
    isLoading.value = true;
    final result = await repo.getSiteInfoWith(siteName);
    if (result.hasError) {
      showOneBtnAlert(result.statusText, "재시도", reload);
      return;
    } else if (!result.body.result) {
      showOneBtnAlert(result.body.msg, "재시도", reload);
      return;
    }

    siteInfo = SiteDateInfo.fromJson(result.body.data["camp"]);
    campInfo = CampInfo.fromJson(result.body.data["info"]);
    final holiday = Map<String, String>.from(result.body.data["holiday"]);
    _updateEvents(siteInfo, holiday);

    isFavorite(_checkFavorite());
    isLoading.value = false;
  }

  void launchHomepageURL() async {
    final url = campInfo.homepageUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchReservationURL() async {
    final url = campInfo.reservationUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchMap() async {
    final url =
        "http://map.naver.com/?zoom=6&query=${Uri.encodeComponent(campInfo.addr)}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void callPhoneNum() async {
    launch("tel://${campInfo.phone}");
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
      events[DateTime.parse(availDate)] = [availSiteInfo];
    }

    // 공휴일 처리
    holiday.forEach((key, value) {
      holidays[DateTime.parse(key)] = [value];
    });
  }

  bool _checkFavorite() {
    if (Constants.user != null) {
      return Constants.user.value.info.favoriteList.contains(siteName);
    } else {
      return false;
    }
  }

  void onClickFavorite() async {
    if (Constants.user.value.isLogin) {
      if (Constants.user.value.info.favoriteList.contains(siteName)) {
        // 즐겨찾기 삭제 api
        final idToken = await Constants.user.value.firebaseUser.getIdToken();
        final result = await userRepo.deleteUserFavoriteList(idToken, siteName);
        if (result.hasError) {
          showOneBtnAlert(result.statusText, "확인", () {});
          return;
        } else if (!result.body.result) {
          showOneBtnAlert(result.body.msg, "확인", () {});
          return;
        }

        Constants.user.value.info.favoriteList.remove(siteName);
        showOneBtnAlert("즐겨찾기 목록에 삭제되었습니다.", "확인", () {
          isFavorite(false);
        });
      } else {
        // 즐겨찾기 추가 api
        final idToken = await Constants.user.value.firebaseUser.getIdToken();
        final result = await userRepo.postUserFavoriteList(idToken, siteName);
        if (result.hasError) {
          showOneBtnAlert(result.statusText, "확인", () {});
          return;
        } else if (!result.body.result) {
          showOneBtnAlert(result.body.msg, "확인", () {});
          return;
        }

        Constants.user.value.info.favoriteList.add(siteName);
        showOneBtnAlert("즐겨찾기 목록에 추가되었습니다.", "확인", () {
          isFavorite(true);
        });
      }
    } else {
      showRequiredLoginAlert();
    }
  }

  void onDaySelected(DateTime day, List siteInfo, List _) {
    if (siteInfo.isEmpty) {
      selectedSiteInfo.value = "";
      return;
    }

    final info = siteInfo[0] as String;

    if (info.isEmpty) {
      selectedSiteInfo.value = "${day.month}월 ${day.day}일 - 자리 상세정보 미지원";
    } else {
      selectedSiteInfo.value = "${day.month}월 ${day.day}일 - $info";
    }
  }
}
