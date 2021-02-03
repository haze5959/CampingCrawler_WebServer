import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/CalenderWidget.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class HomePage extends StatelessWidget {
  final HomeController c = Get.find();

  @override
  Widget build(context) {
    // 업데이트된 count 변수에 연결
    return SingleChildScrollView(child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(maxWidth: MAX_WIDTH),
        child: Column(
          children: <Widget>[
          Obx(() => Text("${c.siteInfoList.length}")),
          CalenderWidget()
        ])));
  }
}
