import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:good_place_camp/Constants.dart';
import "package:flutter_brand_icons/flutter_brand_icons.dart";

// 웹이면 스마트폰을 통해 명당자리 알림을 받으세요
// 모바일이면 매월 2천원 구독으로 쏼라쏼라
class PushPromotionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("명당자리 알림"),
        actions: [],
      ),
      body: Center(
        child: _buildInfoContent(context),
      ),
    );
  }

  Widget _buildInfoContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
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
        Text("ㅇㅇㅇㅇㅇ", style: theme.textTheme.headline2),
        Text("ㅠㅠㅠㅠㅠㅠㅠ", maxLines: 2),
        _buildButtonContent(context)
      ],
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (GetPlatform.isWeb) {
      return Flex(
          direction: Constants.isPhoneSize ? Axis.vertical : Axis.horizontal,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              icon: const Icon(BrandIcons.googleplay, size: 20),
              label: Column(children: [
                Text("GET IT ON",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 10)),
                Text("Google Play",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20))
              ]),
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
              icon: const Icon(BrandIcons.apple, size: 20),
              label: Column(children: [
                Text("Download on the",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 10)),
                Text("App Store",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20))
              ]),
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
    } else {}
  }
}
