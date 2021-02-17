import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/CalenderWidget.dart';
import 'package:good_place_camp/Widget/RecommandSiteWidget.dart';
import 'package:good_place_camp/Widget/RecentlyPostsWidget.dart';
import 'package:good_place_camp/Widget/FooterWidget.dart';

// Controller
import 'package:good_place_camp/Controller/CampDetailContoller.dart';

// Utils
import 'package:good_place_camp/Utils/ZigzagCliper.dart';

class CampDetailPage extends StatelessWidget {
  final String siteName;

  CampDetailPage({
    this.siteName,
  });

  @override
  Widget build(BuildContext context) {
    final CampDetailContoller c = Get.put(CampDetailContoller());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("제모고곡"),
        actions: [
          TextButton(
            child: Text(
              "으아아아앙",
              style: theme.textTheme.bodyText2.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          "센터어어어어",
        ),
      ),
    );
  }
}
