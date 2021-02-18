import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

// Repository
import 'package:good_place_camp/Repository/SiteRepository.dart';

class PostDetailContoller extends GetxController {
  final int id;

  PostDetailContoller({this.id});

  BuildContext context;

  @override
  void onReady() {
    super.onReady();
    reload();
  }

  void reload() async {}
}
