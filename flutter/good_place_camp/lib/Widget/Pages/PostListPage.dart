import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
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

  PostListPage({required this.isNotice});

  @override
  Widget build(BuildContext context) {
    final PostListContoller c = PostListContoller(isNotice);

    if (isNotice) {
      return Scaffold(
          appBar: GPCAppBar(pageName: "board_notice_event".tr(), showFilter: false),
          body: Center(
            child: Container(
                constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                child: Obx(() => Scrollbar(
                        child: ListView.builder(
                      itemCount: c.postList.length + 1,
                      itemBuilder: (context, index) {
                        if (index < c.postList.length) {
                          return _buildListCell(c.postList[index]);
                        } else {
                          c.fetchPosts();
                          return Center(
                                  child: Obx(() => c.isLastPage.value
                                      ? Text("board_info_last").tr()
                                      : CircularProgressIndicator()));
                        }
                      },
                    )))),
          ));
    } else {
      return Scaffold(
          appBar: GPCAppBar(pageName: "board_request_question".tr(), showFilter: false),
          body: Center(
            child: Container(
                constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                child: Obx(() => Scrollbar(
                        child: ListView.builder(
                      itemCount: c.postList.length + 1,
                      itemBuilder: (context, index) {
                        if (index < c.postList.length) {
                          return _buildListCell(c.postList[index]);
                        } else {
                          c.fetchPosts();
                          return Center(
                                  child: Obx(() => c.isLastPage.value
                                      ? Text("board_info_last").tr()
                                      : CircularProgressIndicator()));
                        }
                      },
                    )))),
          ),
          floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              tooltip: "board_wirte_new".tr(),
              child: Icon(Icons.edit),
              backgroundColor: Colors.lightGreen.shade400,
              onPressed: () async {
                bool result = await Get.to(PostWritePage());
                if (result) {
                  c.fetchPosts(reset: true);
                }
              }));
    }
  }

  Widget _buildListCell(Post info) {
    return PostCardItem(info);
  }
}
