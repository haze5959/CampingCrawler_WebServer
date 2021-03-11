import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Widgets
import 'package:good_place_camp/Widget/GPCAppBar.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/TappableCampCardItem.dart';
import 'package:good_place_camp/Widget/Cards/SimpleCampCardItem.dart';

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

    return ListView.builder(
      itemCount: c.siteInfoList.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: TappableCampCardItem(siteInfo: c.siteInfoList[index]));
      },

      //   final campKeys = Constants.campInfo.keys.toList();
      // return ListView.builder(
      //   itemCount: campKeys.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(title: SimpleCampCardItem(siteName: campKeys[index]));
      //   },
      // );
    );
  }

  Widget _buildFavoriteList(BuildContext context) {
    return Obx(() => Constants.favoriteList.length == 0
        ? Center(child: Text("등록된 즐겨찾기 목록이 없습니다."))
        : ListView.builder(
            itemCount: Constants.favoriteList.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: SimpleCampCardItem(
                      siteName: Constants.favoriteList[index]));
            },
          ));
  }
}
