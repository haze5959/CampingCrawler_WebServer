import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

// Repository
import 'package:good_place_camp/Repository/SiteRepository.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class CampDetailContoller extends GetxController {
  final String siteName;

  CampDetailContoller({this.siteName});

  SiteRepository repo = SiteRepository();

  Rx<SiteInfo> siteInfo;

  RxBool isFavorite = false.obs;

  RxBool isLoading = true.obs;

  BuildContext context;

  @override
  void onReady() {
    super.onReady();
    reload();
  }

  void reload() async {
    isLoading.value = true;

    final result = await repo.getSiteInfoWith(siteName);
    if (result.hasError) {
      showOneBtnAlert(result.statusText, "재시도", reload);
      return;
    }

    siteInfo = result.body.obs;

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

  void showOneBtnAlert(String msg, String btnText, Function() confirmAction) {
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
}
