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

class HomePage extends StatelessWidget with WidgetsBindingObserver {
  final HomeController c = Get.find();

  @override
  Widget build(context) {
    WidgetsBinding.instance.addObserver(this);
    c.context = context;

    return Obx(() => Stack(children: [
          RefreshIndicator(
              onRefresh: () async {
                c.reload();
                return;
              },
              child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(
                      child: Column(children: <Widget>[
                    ClipPath(
                      child: Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(
                              top: MAIN_PADDING, bottom: MAIN_PADDING),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: Constants.isPhoneSize
                                ? AssetImage('assets/Banner02.jpg')
                                : AssetImage('assets/Banner01.jpg'),
                            fit: BoxFit.cover,
                          )),
                          child: Column(children: <Widget>[
                            if (!Constants.isPhoneSize) _buildIntroText(),
                            SizedBox(height: 30),
                            CalenderWidget(isVertical: Constants.isPhoneSize)
                          ])),
                      clipper: ZigzagClipPath(),
                    ),
                    RecommandSiteWidget(),
                    RecentlyPostsWidget(isNotice: true),
                    RecentlyPostsWidget(isNotice: false),
                    FooterWidget()
                  ])))),
          if (c.isLoading.value) Center(child: CircularProgressIndicator())
        ]));
  }

  Widget _buildIntroText() {
    return Container(
        constraints: BoxConstraints(maxWidth: MAX_WIDTH),
        alignment: Alignment.centerLeft,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("이제 '명당'에서 캠핑하세요",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 40)),
          Text("매시간 마다 업데이트 되는 캠핑장 예약 정보로 빠르고 편리하게 명당을 예약하세요!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18)),
        ]));
  }
}
