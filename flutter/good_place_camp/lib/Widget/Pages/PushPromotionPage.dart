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
          title: Text("명당캠핑 알림"),
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
        Text("명당캠핑 알림 서비스",
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
                    ? "아이폰으로 매 시간 업데이트 되는\n캠핑장 자리 알림을 받아보세요!"
                    : "스마트폰으로 매 시간 업데이트 되는\n캠핑장 자리 알림을 받아보세요!",
                style: theme.textTheme.subtitle1!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center)),
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
              "매 시간마다 캠핑장 예약 정보 업데이트",
              style: theme.textTheme.subtitle2,
            ),
          ]),
          Row(children: <Widget>[
            Icon(Icons.check, size: 16),
            SizedBox(width: 5),
            Text(
              "즐겨찾기 된 캠핑장의 새로운 예약정보 알림",
              style: theme.textTheme.subtitle2,
            ),
          ]),
          Row(children: <Widget>[
            Icon(Icons.check, size: 16),
            SizedBox(width: 5),
            Text(
              "지역별 캠핑장의 새로운 예약정보 알림",
              style: theme.textTheme.subtitle2,
            ),
          ]),
          Row(children: <Widget>[
            Icon(Icons.check, size: 16),
            SizedBox(width: 5),
            Text(
              "주말 및 공휴일 날 빈자리 알림",
              style: theme.textTheme.subtitle2,
            ),
          ]),
          Row(children: <Widget>[
            Icon(Icons.check, size: 16),
            SizedBox(width: 5),
            Text(
              "예약 오픈일자 알림",
              style: theme.textTheme.subtitle2,
            ),
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
                      Text("푸시 서비스",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              fontSize: 12)),
                      Text("체험하기",
                          style: TextStyle(
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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("서비스 구독 복원하기",
                          style: TextStyle(
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
