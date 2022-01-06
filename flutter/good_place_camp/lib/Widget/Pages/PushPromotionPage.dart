import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Widget/Common/CommonAppBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:good_place_camp/Constants.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

// 모바일이면 매월 2천원 구독으로 쏼라쏼라
class PushPromotionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(pageName: "app_title".tr + "notification".tr),
        body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _buildInfoContent()),
            )));
  }

  Widget _buildInfoContent() {
    final textTheme = Get.theme.textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 120,
          child: Stack(
            children: [
              Positioned.fill(
                child: Ink.image(
                  image: const AssetImage('assets/Camp_Default.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        Text("app_title".tr + "notification_service".tr,
            style: textTheme.headline4!.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        const Divider(
          thickness: 1,
          indent: 40,
          endIndent: 40,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
                GetPlatform.isIOS
                    ? "notification_promotion_ios".tr
                    : "notification_promotion_and".tr,
                style:
                    textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center)),
        const Divider(
          thickness: 1,
          indent: 40,
          endIndent: 40,
        ),
        const SizedBox(height: 20),
        Wrap(direction: Axis.vertical, spacing: 10, children: [
          Row(children: <Widget>[
            const Icon(Icons.check, size: 16),
            const SizedBox(width: 5),
            Text(
              "notification_setting_1".tr,
              style: textTheme.subtitle2,
            ),
          ]),
          Row(children: <Widget>[
            Icon(Icons.check, size: 16),
            const SizedBox(width: 5),
            Text(
              "notification_setting_2".tr,
              style: textTheme.subtitle2,
            ),
          ]),
          Row(children: <Widget>[
            const Icon(Icons.check, size: 16),
            const SizedBox(width: 5),
            Text(
              "notification_setting_3".tr,
              style: textTheme.subtitle2,
            ),
          ]),
          Row(children: <Widget>[
            const Icon(Icons.check, size: 16),
            const SizedBox(width: 5),
            Text(
              "notification_setting_4".tr,
              style: textTheme.subtitle2,
            ),
          ]),
          Row(children: <Widget>[
            const Icon(Icons.check, size: 16),
            const SizedBox(width: 5),
            Text(
              "notification_setting_5".tr,
              style: textTheme.subtitle2,
            ),
          ]),
        ]),
        const SizedBox(height: 30),
        _buildButtonContent(),
        const SizedBox(height: 30)
      ],
    );
  }

  Widget _buildButtonContent() {
    if (GetPlatform.isWeb) {
      return Wrap(
          direction: Constants.isPhoneSize ? Axis.vertical : Axis.horizontal,
          spacing: 15,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              icon: const ImageIcon(AssetImage("assets/ico_google.png"),
                  size: 30),
              label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("GET IT ON",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 10)),
                        const Text("Google Play",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16.8))
                      ])),
              onPressed: () async {
                const url = "";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              icon:
                  const ImageIcon(AssetImage("assets/ico_apple.png"), size: 30),
              label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Download on the",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 11)),
                        const Text("App Store",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20))
                      ])),
              onPressed: () async {
                const url = "";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            )
          ]);
    } else {
      return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Constants.isPhoneSize ? Axis.vertical : Axis.horizontal,
          spacing: 15,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              icon: Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Image.asset('assets/Camp_Main.png',
                      width: 40, height: 40)),
              label: Padding(
                padding: const EdgeInsets.only(right: 35, top: 10, bottom: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("notification_service".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              fontSize: 12)),
                      Text("notification_experience".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20))
                    ]),
              ),
              onPressed: () async {},
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("notification_restore".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20))
                    ]),
              ),
              onPressed: () async {},
            )
          ]);
    }
  }
}
