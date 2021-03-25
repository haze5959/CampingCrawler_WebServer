import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Repository
import 'package:good_place_camp/Repository/SiteRepository.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class CampDetailContoller extends GetxController {
  final String siteName;

  CampDetailContoller({this.siteName}) {
    reload();
  }

  SiteRepository repo = SiteRepository();

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

  void _updateEvents(SiteInfo info) {
    events.clear();

    for (var date in info.availDates) {
      events[DateTime.parse(date)] = [info];
    }
  }

  bool _checkFavorite() {
    return Constants.favoriteList.contains(siteName);
  }

  void onClickFavorite() async {
    if (Constants.favoriteList.contains(siteName)) {
      Constants.favoriteList.remove(siteName);
      isFavorite(false);
    } else {
      Constants.favoriteList.add(siteName);
      isFavorite(true);
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("CAMP_FAVORITE", Constants.favoriteList);
  }
}
