import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/CalenderWidget.dart';
import 'package:good_place_camp/Widget/RecommandSiteWidget.dart';
import 'package:good_place_camp/Widget/RecentlyPostsWidget.dart';
import 'package:good_place_camp/Widget/FooterWidget.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Utils
import 'package:good_place_camp/Utils/ZigzagCliper.dart';

class HomePage extends StatelessWidget {
  final HomeController c = Get.find();

  @override
  Widget build(context) {
    c.context = context;

    return SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
            child: Column(children: <Widget>[
          ClipPath(
            child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(
                    top: MAIN_PADDING, bottom: MAIN_PADDING * 2),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: IS_PHONE_SIZE ? AssetImage('assets/Banner02.jpg') : AssetImage('assets/Banner01.jpg'),
                  fit: BoxFit.cover,
                )),
                child: Column(children: <Widget>[
                  if (!IS_PHONE_SIZE) _buildIntroText(),
                  CalenderWidget(isVertical: IS_PHONE_SIZE)
                ])),
            clipper: ZigzagClipPath(),
          ),
          RecommandSiteWidget(),
          RecentlyPostsWidget(),
          FooterWidget()
          
        ])));
  }

  Widget _buildIntroText() {
    return Container(
        constraints: BoxConstraints(maxWidth: MAX_WIDTH),
        alignment: Alignment.centerLeft,
        child: Text("이제 '명당'에서 캠핑하세요",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40),
            textAlign: TextAlign.left));
  }
}
