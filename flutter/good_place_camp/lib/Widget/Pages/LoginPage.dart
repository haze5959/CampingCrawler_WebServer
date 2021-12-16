import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller
import 'package:good_place_camp/Controller/LoginController.dart';
import 'package:good_place_camp/Widget/CommonAppBar.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginController c = LoginController();

    return Scaffold(
        appBar: CommonAppBar(
          pageName: "login".tr,
        ),
        body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Obx(() =>
                Stack(alignment: AlignmentDirectional.center, children: [
                  Center(
                    child: Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 120,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Ink.image(
                                      image: const AssetImage(
                                          'assets/Camp_Default.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text("app_title".tr + "login".tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25)),
                            const SizedBox(height: 20),
                            const Divider(
                              thickness: 1,
                              indent: 40,
                              endIndent: 40,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Text("login_promotion".tr,
                                    textAlign: TextAlign.center)),
                            const Divider(
                              thickness: 1,
                              indent: 40,
                              endIndent: 40,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepOrange[700],
                                    minimumSize: Size(340, 50)),
                                icon: const ImageIcon(
                                    const AssetImage("assets/ico_google.png"),
                                    size: 16),
                                label: Text("login_google".tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontSize: 16)),
                                onPressed: () async {
                                  final isSuccess = await c.logInWithGoogle();
                                  if (isSuccess) {
                                    Get.back();
                                  }
                                }),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[700],
                                    minimumSize: Size(340, 50)),
                                icon: const ImageIcon(
                                    const AssetImage("assets/ico_facebook.png"),
                                    size: 16),
                                label: Text("login_facebook".tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontSize: 16)),
                                onPressed: () async {
                                  final isSuccess = await c.logInWithFacebook();
                                  if (isSuccess) {
                                    Get.back();
                                  }
                                }),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.lightBlue[600],
                                    minimumSize: Size(340, 50)),
                                icon: const ImageIcon(
                                    const AssetImage("assets/ico_twitter.png"),
                                    size: 16),
                                label: Text("login_twitter".tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontSize: 16)),
                                onPressed: () async {
                                  final isSuccess = await c.logInWithTwitter();
                                  if (isSuccess) {
                                    Get.back();
                                  }
                                }),
                            const SizedBox(height: 20),
                            if (!GetPlatform.isAndroid)
                              ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black,
                                      minimumSize: Size(340, 50)),
                                  icon: const ImageIcon(
                                    const AssetImage("assets/ico_apple.png"),
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  label: Text("login_apple".tr,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontSize: 16)),
                                  onPressed: () async {
                                    final isSuccess = await c.logInWithApple();
                                    if (isSuccess) {
                                      Get.back();
                                    }
                                  }),
                            const SizedBox(height: 40),
                          ],
                        )),
                  ),
                  if (c.isLoading.value) const CircularProgressIndicator()
                ]))));
  }
}
