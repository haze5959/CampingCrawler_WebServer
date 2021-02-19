import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/GPCAppBar.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

class PostListPage extends StatelessWidget {
  final String siteName;

  PostListPage({this.siteName});

  @override
  Widget build(BuildContext context) {
    final HomeController c = Get.find();

    return Scaffold(
      appBar: GPCAppBar(pageName: "게시글", showFilter: false),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: Text("홈페이지"),
              onPressed: () {
                
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: Text("예약 사이트"),
              onPressed: () {
                
              },
            ),
          ],
        ),
      ),
    );
  }
}
