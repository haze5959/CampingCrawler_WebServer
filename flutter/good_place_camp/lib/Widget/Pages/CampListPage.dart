import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/GPCAppBar.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/TappableCampCardItem.dart';
import 'package:good_place_camp/Widget/Cards/SimpleCampCardItem.dart';
import 'package:good_place_camp/Widget/Cards/PromotionCardItem.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

class CampListPage extends StatelessWidget {
  final bool isFavoritePage;

  CampListPage({this.isFavoritePage = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFavoritePage
          ? GPCAppBar(pageName: "나만의 캠핑장", showFilter: false)
          : GPCAppBar(pageName: "캠핑장", showFilter: true),
      body: Center(
        child: Container(
            constraints: BoxConstraints(maxWidth: MAX_WIDTH),
            child: Scrollbar(
                child: isFavoritePage
                    ? _buildFavoriteList(context)
                    : _buildCampList(context))),
      ),
    );
  }

  Widget _buildCampList(BuildContext context) {
    final HomeController c = Get.find();

    return Obx(() => ListView.builder(
          itemCount: c.siteInfoList.length + 1,
          itemBuilder: (context, index) {
            if (index < c.siteInfoList.length) {
              return ListTile(
                  title: TappableCampCardItem(siteInfo: c.siteInfoList[index]));
            } else {
              return ListTile(title: PromotionCardItem());
            }
          },
        ));
  }

  Widget _buildFavoriteList(BuildContext context) {
    return Obx(() => ListView.builder(
          itemCount: Constants.user.value.info.favoriteList.length + 1,
          itemBuilder: (context, index) {
            if (index < Constants.user.value.info.favoriteList.length) {
              return ListTile(
                  title: SimpleCampCardItem(
                      siteName: Constants.user.value.info.favoriteList[index]));
            } else {
              return ListTile(title: PromotionCardItem());
            }
          },
        ));
  }
}
