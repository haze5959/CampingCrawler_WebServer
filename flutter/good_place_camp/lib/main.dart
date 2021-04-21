import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:firebase_core/firebase_core.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/HomePage.dart';
import 'package:good_place_camp/Widget/GPCAppBar.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(home: Home(), localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
    ], supportedLocales: [
      const Locale('ko', 'KR')
    ]));
}

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    final HomeController c = Get.put(HomeController());

    Constants.isPhoneSize = context.mediaQuerySize.width < MAX_WIDTH;

    return Scaffold(
        appBar: GPCAppBar(pageName: "명당캠핑", showFilter: true, isMain: true),
        body: Center(child: HomePage()),
        backgroundColor: Colors.lightGreen.shade50);
  }
}