import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/HomePage.dart';
import 'package:good_place_camp/Widget/GPCAppBar.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      supportedLocales: [Locale('ko', 'KR')],
      path: 'assets/translations',
      fallbackLocale: Locale('ko', 'KR'),
      child: Home()));
}

class Home extends StatelessWidget {
  Future<void> _initApp() async {
    await Firebase.initializeApp();
    if (GetPlatform.isWeb) {
      Constants.auth.setPersistence(Persistence.LOCAL);
      return;
    }
  }

  @override
  Widget build(context) {
    return GetMaterialApp(
        home: _body(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale);
  }

  Widget _body() {
    return FutureBuilder(
      future: _initApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          Get.put(HomeController());
          Constants.isPhoneSize = context.mediaQuerySize.width < MAX_WIDTH;
          return Scaffold(
              appBar:
                  GPCAppBar(pageName: 'app_title'.tr(), showFilter: true, isMain: true),
              body: Center(child: HomePage()),
              backgroundColor: Colors.lightGreen.shade50);
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
