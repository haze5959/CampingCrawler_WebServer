import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:good_place_camp/Widget/Pages/CampDetailPage.dart';
import 'package:good_place_camp/Widget/Pages/CampListPage.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/HomePage.dart';
import 'package:good_place_camp/Widget/Pages/LoginPage.dart';
import 'package:good_place_camp/Widget/Pages/PostDetailPage.dart';
import 'package:good_place_camp/Widget/Pages/PostListPage.dart';
import 'package:good_place_camp/Widget/Pages/PostWritePage.dart';
import 'package:good_place_camp/Widget/Pages/PushPromotionPage.dart';
import 'package:good_place_camp/Widget/Pages/PushSettingPage.dart';
import 'package:good_place_camp/Widget/Pages/UserInfoPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      supportedLocales: [Locale('ko', 'KR')],
      path: 'translations',
      fallbackLocale: Locale('ko', 'KR'),
      child: Home()));
}

class Home extends StatelessWidget {
  Future<void> _initApp() async {
    await Firebase.initializeApp();
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
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
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
