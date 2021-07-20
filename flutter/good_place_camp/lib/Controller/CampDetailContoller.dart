import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Repository
import 'package:good_place_camp/Repository/SiteRepository.dart';
import 'package:good_place_camp/Repository/UserRepository.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class CampDetailContoller extends GetxController {
  final String siteName;

  CampDetailContoller({this.siteName}) {
    reload();
  }

  final SiteRepository repo = SiteRepository();
  final UserRepository userRepo = UserRepository();

  SiteInfo siteInfo;

  Rx<bool> isFavorite = Rx<bool>(false);

  RxBool isLoading = true.obs;

  CalendarController calendarController = CalendarController();

  Map<DateTime, List<SiteInfo>> events = Map<DateTime, List<SiteInfo>>();

  void reload() async {
    isLoading.value = true;
    final result = await repo.getSiteInfoWith(siteName);
    if (result.hasError) {
      showOneBtnAlert(Get.context, result.statusText, "재시도", reload);
      return;
    } else if (!result.body.result) {
      showOneBtnAlert(Get.context, result.body.msg, "재시도", reload);
      return;
    }

    siteInfo = SiteInfo.fromJson(result.body.data);
    _updateEvents(siteInfo);

    isFavorite(_checkFavorite());
    isLoading.value = false;
  }

  void launchHomepageURL() async {
    final url = Constants.campInfo[siteName].homepageUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchReservationURL() async {
    final url = Constants.campInfo[siteName].reservationUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchMap() async {
    final url =
        "http://map.naver.com/?zoom=6&query=${Uri.encodeComponent(Constants.campInfo[siteName].addr)}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _updateEvents(SiteInfo info) {
    events.clear();

    for (var date in info.availDates) {
      if (date.isEmpty) {
        break;
      }
      events[DateTime.parse(date)] = [info];
    }
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
          showOneBtnAlert(Get.context, result.statusText, "확인", () {});
          return;
        } else if (!result.body.result) {
          showOneBtnAlert(Get.context, result.body.msg, "확인", () {});
          return;
        }

        Constants.user.value.info.favoriteList.remove(siteName);
        showOneBtnAlert(Get.context, "즐겨찾기 목록에 삭제되었습니다.", "확인", () {
          isFavorite(false);
        });
      } else {
        // 즐겨찾기 추가 api
        final idToken = await Constants.user.value.firebaseUser.getIdToken();
        final result = await userRepo.postUserFavoriteList(idToken, siteName);
        if (result.hasError) {
          showOneBtnAlert(Get.context, result.statusText, "확인", () {});
          return;
        } else if (!result.body.result) {
          showOneBtnAlert(Get.context, result.body.msg, "확인", () {});
          return;
        }

        Constants.user.value.info.favoriteList.add(siteName);
        showOneBtnAlert(Get.context, "즐겨찾기 목록에 추가되었습니다.", "확인", () {
          isFavorite(true);
        });
      }
    } else {
      showRequiredLoginAlert();
    }
  }
}
