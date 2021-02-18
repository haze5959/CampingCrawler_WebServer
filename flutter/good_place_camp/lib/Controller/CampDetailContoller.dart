import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

// Repository
import 'package:good_place_camp/Repository/SiteRepository.dart';

class CampDetailContoller extends GetxController {
  final String siteName;

  CampDetailContoller({this.siteName});

  SiteRepository repo = SiteRepository();

  var isFavorite = false.obs;

  BuildContext context;

  @override
  void onReady() {
    super.onReady();
    reload();
  }

  void reload() async {}

  void launchURL(String urlKey) async {
    final url = CAMP_INFO[siteName][urlKey];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
