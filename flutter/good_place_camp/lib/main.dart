import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  runApp(GetMaterialApp(home: Home(), localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
  ], supportedLocales: [
    const Locale('ko', 'KR')
  ]));
}

class Home extends StatelessWidget {
  Future<void> _initApp() async {
    if (GetPlatform.isWeb) {
      await Firebase.initializeApp();
      return Constants.auth.setPersistence(Persistence.LOCAL);
    } else {
      return Firebase.initializeApp();
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
          final HomeController c = Get.put(HomeController());
          Constants.isPhoneSize = context.mediaQuerySize.width < MAX_WIDTH;

          return Scaffold(
              appBar:
                  GPCAppBar(pageName: "명당캠핑", showFilter: true, isMain: true),
              body: Center(child: HomePage()),
              backgroundColor: Colors.lightGreen.shade50);
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
