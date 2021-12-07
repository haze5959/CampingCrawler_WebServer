import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

// Controller
import 'package:good_place_camp/Controller/LoginController.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginController c = LoginController();

    return Scaffold(
        appBar: AppBar(
          title: const Text("login").tr(),
          actions: [],
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
                                      image:
                                          const AssetImage('assets/Camp_Default.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text("app_title".tr() + "login".tr(),
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
                                child: const Text(
                                    "login_promotion",
                                    textAlign: TextAlign.center).tr()),
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
                                label: const Text("login_google",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontSize: 16)).tr(),
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
                                label: const Text("login_facebook",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontSize: 16)).tr(),
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
                                label: Text("login_twitter".tr(),
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
                                  label: const Text("login_apple",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontSize: 16)).tr(),
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
