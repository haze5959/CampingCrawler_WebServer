import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:flutter_brand_icons/flutter_brand_icons.dart";
// import 'package:good_place_camp/Constants.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// Controller
import 'package:good_place_camp/Controller/LoginController.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginController c = LoginController();

    return Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.red[300]),
              icon: const Icon(BrandIcons.googleplay, size: 30),
              label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Download on the",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 11)),
                        Text("App Store",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20))
                      ])),
              onPressed: () async {
                final credential = await c.logInWithGoogle();
                credential.printInfo();
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.blue[300]),
              icon: const Icon(BrandIcons.facebook, size: 30),
              label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Download on the",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 11)),
                        Text("App Store",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20))
                      ])),
              onPressed: () async {
                final credential = await c.logInWithFacebook();
                credential.printInfo();
              },
            ),
            if (!GetPlatform.isAndroid)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.black),
                icon: const Icon(BrandIcons.apple, size: 30),
                label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Download on the",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 11)),
                          Text("App Store",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20))
                        ])),
                onPressed: () async {
                  final credential = await c.logInWithApple();
                  credential.printInfo();
                },
              ),
          ],
        ),
      ),
    );
  }
}
