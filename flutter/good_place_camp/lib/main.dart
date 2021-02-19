import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/HomePage.dart';
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

    IS_PHONE_SIZE = context.mediaQuerySize.width < MAX_WIDTH;

    return Scaffold(appBar: GPCAppBar(pageName: "명당캠핑", showFilter: true), body: Center(child: HomePage()), backgroundColor: Colors.lightGreen.shade50);
  }
}

// 카피 사이트
// https://www.skyscanner.co.kr