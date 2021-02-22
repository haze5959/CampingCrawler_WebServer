import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/GPCAppBar.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/TappableCampCardItem.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class CampListPage extends StatelessWidget {
  final String siteName;

  CampListPage({this.siteName});

  @override
  Widget build(BuildContext context) {
    final HomeController c = Get.find();

    return Scaffold(
      appBar: GPCAppBar(pageName: "캠핑장", showFilter: true),
      body: Center(
        child: Container(
            constraints: BoxConstraints(maxWidth: MAX_WIDTH),
            child: Scrollbar(
                child: ListView.builder(
              itemCount: c.siteInfoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: _buildListCell(context, c.siteInfoList[index]),
                );
              },
            ))),
      ),
    );
  }

  Widget _buildListCell(BuildContext context, SiteInfo siteInfo) {
    return TappableCampCardItem(siteInfo: siteInfo);
  }
}
