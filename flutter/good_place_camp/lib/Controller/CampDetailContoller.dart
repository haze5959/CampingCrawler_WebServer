import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Repository
import 'package:good_place_camp/Repository/SiteRepository.dart';

class CampDetailContoller extends GetxController {
  SiteRepository repo = SiteRepository();

  BuildContext context;

  @override
  void onReady() {
    super.onReady();
    reload();
  }

  void reload() async {

  }
}
