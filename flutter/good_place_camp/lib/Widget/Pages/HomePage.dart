import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/CalenderWidget.dart';
import 'package:good_place_camp/Widget/RecommandSiteWidget.dart';
import 'package:good_place_camp/Widget/RecentlyPostsWidget.dart';
import 'package:good_place_camp/Widget/FooterWidget.dart';
import 'package:good_place_camp/Widget/ObxLoadingWidget.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Utils
import 'package:good_place_camp/Utils/ZigzagCliper.dart';

class HomePage extends StatelessWidget with WidgetsBindingObserver {
  final HomeController c = Get.find();

  @override
  Widget build(context) {
    return Stack(children: [
      RefreshIndicator(
          onRefresh: () async {
            c.reload();
            return;
          },
          child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                  child: Column(children: <Widget>[
                ClipPath(
                  child: Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(
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
      obxLoadingWidget(c.isLoading)
    ]);
  }

  Widget _buildIntroText() {
    return Container(
        constraints: const BoxConstraints(maxWidth: MAX_WIDTH),
        alignment: Alignment.centerLeft,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("home_title_1",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 40))
              .tr(),
          const Text("home_title_2",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18))
              .tr(),
        ]));
  }
}
