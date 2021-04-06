import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/GPCAppBar.dart';
import 'package:good_place_camp/Widget/Pages/PostWritePage.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/PostCardItem.dart';

// Controller
import 'package:good_place_camp/Controller/PostListContoller.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostListPage extends StatelessWidget {
  final bool isNotice; // 공지사항 뷰인지

  PostListPage({this.isNotice});

  @override
  Widget build(BuildContext context) {
    final PostListContoller c = PostListContoller(isNotice: isNotice);

    if (isNotice) {
      return Scaffold(
          appBar: GPCAppBar(pageName: "공지사항/이벤트", showFilter: false),
          body: Center(
            child: Container(
                constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                child: Obx(() => Scrollbar(
                        child: ListView.builder(
                      itemCount: c.postList.length + 1,
                      itemBuilder: (context, index) {
                        if (index < c.postList.length) {
                          return ListTile(
                              title: _buildListCell(c.postList[index]));
                        } else {
                          c.fetchPosts();
                          return ListTile(
                              title: Center(
                                  child: Obx(() => c.isLastPage.value
                                      ? Text("마지막 글 입니다.")
                                      : CircularProgressIndicator())));
                        }
                      },
                    )))),
          ));
    } else {
      return Scaffold(
          appBar: GPCAppBar(pageName: "요청/문의", showFilter: false),
          body: Center(
            child: Container(
                constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                child: Obx(() => Scrollbar(
                        child: ListView.builder(
                      itemCount: c.postList.length + 1,
                      itemBuilder: (context, index) {
                        if (index < c.postList.length) {
                          return ListTile(
                              title: _buildListCell(c.postList[index]));
                        } else {
                          c.fetchPosts();
                          return ListTile(
                              title: Center(
                                  child: Obx(() => c.isLastPage.value
                                      ? Text("마지막 글 입니다.")
                                      : CircularProgressIndicator())));
                        }
                      },
                    )))),
          ),
          floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              tooltip: "새 글쓰기",
              child: Icon(Icons.edit),
              backgroundColor: Colors.lightGreen.shade400,
              onPressed: () async {
                final result = await Get.to(PostWritePage());
                if (result != null && result) {
                  c.fetchPosts(reset: true);
                }
              }));
    }
  }

  Widget _buildListCell(Post info) {
    return PostCardItem(info: info);
  }
}
