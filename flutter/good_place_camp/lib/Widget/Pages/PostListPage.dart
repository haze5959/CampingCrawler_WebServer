import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/GPCAppBar.dart';
import 'package:good_place_camp/Widget/Pages/PostWritePage.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/PostCardItem.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostListPage extends StatelessWidget {
  final String siteName;

  PostListPage({this.siteName});

  @override
  Widget build(BuildContext context) {
    final HomeController c = Get.find();

    return Scaffold(
        appBar: GPCAppBar(pageName: "게시판", showFilter: false),
        body: Center(
          child: Container(
              constraints: BoxConstraints(maxWidth: MAX_WIDTH),
              child: Scrollbar(
                  child: ListView.builder(
                itemCount: c.postList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: _buildListCell(c.postList[index]),
                  );
                },
              ))),
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            tooltip: "새 글쓰기",
            child: Icon(Icons.edit),
            backgroundColor: Colors.lightGreen.shade400,
            onPressed: () {
              Get.to(PostWritePage());
            }));
  }

  Widget _buildListCell(Post info) {
    return PostCardItem(info: info);
  }
}
