import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:good_place_camp/Constants.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

// 모바일이면 매월 2천원 구독으로 쏼라쏼라
class PushPromotionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("app_title".tr() + "notification".tr()),
          actions: [],
        ),
        body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Center(
              child: Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: _buildInfoContent(context)),
            )));
  }

  Widget _buildInfoContent(BuildContext context) {
    final theme = Theme.of(context);

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
                  image: AssetImage('assets/Camp_Default.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        Text("app_title".tr() + "notification_service".tr(),
            style: theme.textTheme.headline4!
                .copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Divider(
          thickness: 1,
          indent: 40,
          endIndent: 40,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
                GetPlatform.isIOS
                    ? "notification_promotion_ios"
                    : "notification_promotion_and",
                style: theme.textTheme.subtitle1!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center).tr()),
        Divider(
          thickness: 1,
          indent: 40,
          endIndent: 40,
        ),
        SizedBox(height: 20),
        Wrap(direction: Axis.vertical, spacing: 10, children: [
          Row(children: <Widget>[
            Icon(Icons.check, size: 16),
            SizedBox(width: 5),
            Text(
              "notification_setting_1",
              style: theme.textTheme.subtitle2,
            ).tr(),
          ]),
          Row(children: <Widget>[
            Icon(Icons.check, size: 16),
            SizedBox(width: 5),
            Text(
              "notification_setting_2",
              style: theme.textTheme.subtitle2,
            ).tr(),
          ]),
          Row(children: <Widget>[
            Icon(Icons.check, size: 16),
            SizedBox(width: 5),
            Text(
              "notification_setting_3",
              style: theme.textTheme.subtitle2,
            ).tr(),
          ]),
          Row(children: <Widget>[
            Icon(Icons.check, size: 16),
            SizedBox(width: 5),
            Text(
              "notification_setting_4",
              style: theme.textTheme.subtitle2,
            ).tr(),
          ]),
          Row(children: <Widget>[
            Icon(Icons.check, size: 16),
            SizedBox(width: 5),
            Text(
              "notification_setting_5",
              style: theme.textTheme.subtitle2,
            ).tr(),
          ]),
        ]),
        SizedBox(height: 30),
        _buildButtonContent(context),
        SizedBox(height: 30)
      ],
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (GetPlatform.isWeb) {
      return Wrap(
          direction: Constants.isPhoneSize ? Axis.vertical : Axis.horizontal,
          spacing: 15,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              icon: ImageIcon(AssetImage("assets/ico_google.png"), size: 30),
              label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("GET IT ON",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 10)),
                        Text("Google Play",
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
              icon: ImageIcon(AssetImage("assets/ico_apple.png"), size: 30),
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
                  padding: EdgeInsets.only(left: 35),
                  child: Image.asset('assets/Camp_Main.png',
                      width: 40, height: 40)),
              label: Padding(
                padding: EdgeInsets.only(right: 35, top: 10, bottom: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("notification_service",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              fontSize: 12)).tr(),
                      Text("notification_experience",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20)).tr()
                    ]),
              ),
              onPressed: () async {},
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("notification_restore",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20)).tr()
                    ]),
              ),
              onPressed: () async {},
            )
          ]);
    }
  }
}
