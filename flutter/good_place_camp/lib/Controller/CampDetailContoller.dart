import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  BuildContext context;

  void reload() async {
    isLoading.value = true;
    final result = await repo.getSiteInfoWith(siteName);
    if (result.hasError) {
      _showOneBtnAlert(result.statusText, "재시도", reload);
      return;
    }

    siteInfo = result.body;
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

  void _showOneBtnAlert(String msg, String btnText, Function() confirmAction) {
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
