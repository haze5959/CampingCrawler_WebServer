import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/Common/GPCAppBar.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/PostFeedItem.dart';

// Controller
import 'package:good_place_camp/Controller/PostListContoller.dart';

class PostListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isNotice = Get.parameters['is_notice'] == 'true' ? true : false;
    final PostListContoller c = PostListContoller(isNotice: isNotice);

    if (isNotice) {
      return Scaffold(
          appBar:
              GPCAppBar(pageName: "board_notice_event".tr, showFilter: false),
          body: _buildPostList(c));
    } else {
      return Scaffold(
          appBar: GPCAppBar(
              pageName: "board_request_question".tr, showFilter: false),
          body: _buildPostList(c),
          floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              tooltip: "board_wirte_new".tr,
              child: const Icon(Icons.edit),
              backgroundColor: Colors.lightGreen.shade400,
              onPressed: () async {
                bool result = await Get.toNamed("/board/write");
                if (result) {
                  c.fetchPosts(reset: true);
                }
              }));
    }
  }

  Widget _buildPostList(PostListContoller c) {
    return Center(
        child: Container(
      constraints: const BoxConstraints(maxWidth: POSTS_CARD_MAX_WIDTH),
      child: Obx(() => ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: CARD_SPACE,
              );
            },
            itemCount: c.postList.length + 1,
            itemBuilder: (context, index) {
              if (index < c.postList.length) {
                return PostFeedItem(c.postList[index]);
              } else {
                c.fetchPosts();
                return Center(
                    child: Obx(() => c.isLastPage.value
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: CARD_SPACE),
                            child: Text("board_info_last".tr))
                        : const CircularProgressIndicator()));
              }
            },
          )),
    ));
  }
}
