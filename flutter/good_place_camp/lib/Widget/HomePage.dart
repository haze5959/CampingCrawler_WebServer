import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class HomePage extends StatelessWidget {
  final HomeController c = Get.find();

  @override
  Widget build(context) {
    // 업데이트된 count 변수에 연결
    return Scaffold(
        body: Center(child: Obx(() => Text("${c.siteInfoList.length}"))));
  }
}
