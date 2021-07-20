import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:flutter_brand_icons/flutter_brand_icons.dart";

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
        body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Obx(() => Stack(
              alignment: AlignmentDirectional.center,
              children: [
                  Center(
                    child: Container(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 120,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Ink.image(
                                      image:
                                          AssetImage('assets/Camp_Default.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text("명당캠핑 로그인",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25)),
                            SizedBox(height: 20),
                            Divider(
                              thickness: 1,
                              indent: 40,
                              endIndent: 40,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                    "SNS 로그인으로 회원가입 절차 없이 바로 시작해보세요!\n나만의 캠핑장 리스트를 빠르고 편리하게\n확인/알림 받을 수 있습니다!",
                                    textAlign: TextAlign.center)),
                            Divider(
                              thickness: 1,
                              indent: 40,
                              endIndent: 40,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepOrange[700],
                                    minimumSize: Size(340, 50)),
                                icon: const Icon(BrandIcons.google, size: 16),
                                label: Text("Google로 계속하기",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontSize: 16)),
                                onPressed: () async {
                                  final isSuccess = await c.logInWithGoogle();
                                  if (isSuccess) {
                                    Get.back();
                                  }
                                }),
                            SizedBox(height: 20),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[700],
                                    minimumSize: Size(340, 50)),
                                icon: const Icon(BrandIcons.facebook, size: 16),
                                label: Text("Facebook으로 계속하기",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontSize: 16)),
                                onPressed: () async {
                                  final isSuccess = await c.logInWithFacebook();
                                  if (isSuccess) {
                                    Get.back();
                                  }
                                }),
                            SizedBox(height: 20),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.lightBlue[600],
                                    minimumSize: Size(340, 50)),
                                icon: const Icon(BrandIcons.twitter, size: 16),
                                label: Text("Twitter으로 계속하기",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontSize: 16)),
                                onPressed: () async {
                                  final isSuccess = await c.logInWithTwitter();
                                  if (isSuccess) {
                                    Get.back();
                                  }
                                }),
                            SizedBox(height: 20),
                            if (!GetPlatform.isAndroid)
                              ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black,
                                      minimumSize: Size(340, 50)),
                                  icon: const Icon(
                                    BrandIcons.apple,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  label: Text("Apple로 계속하기",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontSize: 16)),
                                  onPressed: () async {
                                    final isSuccess = await c.logInWithApple();
                                    if (isSuccess) {
                                      Get.back();
                                    }
                                  }),
                            SizedBox(height: 40),
                          ],
                        )),
                  ),
                  if (c.isLoading.value) CircularProgressIndicator()
                ]))));
  }
}
