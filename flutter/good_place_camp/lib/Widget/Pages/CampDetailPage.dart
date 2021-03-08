import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/CampDetailContoller.dart';

class CampDetailPage extends StatelessWidget {
  final String siteName;

  CampDetailPage({this.siteName});

  @override
  Widget build(BuildContext context) {
    final CampDetailContoller c = CampDetailContoller(siteName: siteName);

    final infoJson = CAMP_INFO[siteName];

    return Scaffold(
      appBar: AppBar(
        title: Text(infoJson.name),
        actions: [
          Obx(() => IconButton(
                icon: c.isFavorite.value
                    ? Icon(Icons.star, color: Colors.yellow)
                    : Icon(Icons.star_border_outlined, color: Colors.white),
                onPressed: () {
                  // Navigator.pop(context);
                  // 즐겨찾기 로직 필요
                },
              )),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: Text("홈페이지"),
              onPressed: () {
                c.launchHomepageURL();
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: Text("예약 사이트"),
              onPressed: () {
                c.launchReservationURL();
              },
            ),
          ],
        ),
      ),
    );
  }
}
