import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

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
    final HomeController c = Get.find();

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
                    : _buildCampList(context, c))),
      ),
    );
  }

  Widget _buildCampList(BuildContext context, HomeController c) {
    return ListView.builder(
      itemCount: c.siteInfoList.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: TappableCampCardItem(siteInfo: c.siteInfoList[index]));
      },
    );
  }

  Widget _buildFavoriteList(BuildContext context) {
    final campKeys = Constants.campInfo.keys.toList();
    return ListView.builder(
      itemCount: campKeys.length,
      itemBuilder: (context, index) {
        return ListTile(title: SimpleCampCardItem(siteName: campKeys[index]));
      },
    );
  }
}
