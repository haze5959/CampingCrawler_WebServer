import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:good_place_camp/Utils/translations/ko-KR.dart';
import 'package:good_place_camp/Widget/Pages/CampDetailPage.dart';
import 'package:good_place_camp/Widget/Pages/CampListPage.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

import 'package:dio/dio.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/HomePage.dart';
import 'package:good_place_camp/Widget/Pages/LoginPage.dart';
import 'package:good_place_camp/Widget/Pages/PostDetailPage.dart';
import 'package:good_place_camp/Widget/Pages/PostListPage.dart';
import 'package:good_place_camp/Widget/Pages/PostWritePage.dart';
import 'package:good_place_camp/Widget/Pages/PushPromotionPage.dart';
import 'package:good_place_camp/Widget/Pages/PushSettingPage.dart';
import 'package:good_place_camp/Widget/Pages/UserInfoPage.dart';

// Model
import 'package:good_place_camp/Model/CampInfo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Home());
}

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'ko_KR': trJson};
}

class Home extends StatelessWidget {
  Future<void> _initApp() async {
    await Firebase.initializeApp();

    try {
      final res = await ApiRepo.site.getAllSiteJson();
      if (!res.result) {
        showServerErrorAlert(res.msg, false);
        return;
      }

      final data = res.data!;
      Constants.campInfoMap = toCampInfoMap(data);
    } on DioError catch (ex) {
      print(ex.message);
      showServerErrorAlert("server_error".tr, false);
    }
  }

  @override
  Widget build(context) {
    return FutureBuilder(
      future: _initApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          if (GetPlatform.isWeb) {
            Constants.auth.setPersistence(Persistence.LOCAL);
          }

          return GetMaterialApp(
            translations: Messages(),
            locale: const Locale('ko', 'KR'),
            fallbackLocale: const Locale('ko', 'KR'),
            supportedLocales: [const Locale('ko', 'KR')],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
            ],
            initialRoute: "/",
            getPages: [
              GetPage(name: "/", page: () => HomePage()),
              GetPage(name: "/login", page: () => LoginPage()),
              GetPage(name: "/myinfo", page: () => UserInfoPage()),
              GetPage(name: "/push", page: () => PushSettingPage()),
              GetPage(name: "/promotion", page: () => PushPromotionPage()),
              GetPage(name: "/camp/list", page: () => CampListPage()),
              GetPage(name: "/camp/detail/:id", page: () => CampDetailPage()),
              GetPage(name: "/board/list", page: () => PostListPage()),
              GetPage(name: "/board/detail/:id", page: () => PostDetailPage()),
              GetPage(name: "/board/write", page: () => PostWritePage()),
            ],
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
