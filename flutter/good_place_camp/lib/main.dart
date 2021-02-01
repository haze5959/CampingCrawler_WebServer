import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Widgets
import 'package:good_place_camp/Widget/HomePage.dart';
import 'package:good_place_camp/Widget/GPCAppBar.dart';
// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

void main() => runApp(GetMaterialApp(home: Home(), localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ], supportedLocales: [const Locale('ko', 'KR')]));

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    final HomeController c = Get.put(HomeController());

    return Scaffold(appBar: GPCAppBar(), body: HomePage());
  }
}

// 카피 사이트
// https://www.skyscanner.co.kr