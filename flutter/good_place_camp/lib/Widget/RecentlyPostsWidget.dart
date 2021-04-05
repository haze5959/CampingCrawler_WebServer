import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

// Widgets
import 'package:good_place_camp/Widget/Cards/PostCardItem.dart';
import 'package:good_place_camp/Widget/Pages/PostListPage.dart';
import 'package:good_place_camp/Widget/Pages/PostWritePage.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

class RecentlyPostsWidget extends StatelessWidget {
  final bool isNotice; // 공지사항 뷰인지

  RecentlyPostsWidget({this.isNotice});

  @override
  Widget build(context) {
    final HomeController c = Get.find();

    return Container(
        constraints: BoxConstraints(maxWidth: MAX_WIDTH),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Row(children: [
              Text(isNotice ? "공지사항/이벤트" : "요청/문의 게시판",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
              SizedBox(width: 10),
              FloatingActionButton(
                heroTag: isNotice ? "RecentlyNoticePosts" : "RecentlyPosts",
                backgroundColor: Colors.lightGreen.shade300,
                mini: true,
                child: const Icon(Icons.list),
                onPressed: () async {
                  await Navigator.push<void>(
                      context,
                      CupertinoPageRoute(
                    builder: (context) => PostListPage(isNotice: isNotice),
                  ));

                  c.updatePostList();
                },
              ),
              SizedBox(width: 10),
              if (!isNotice)
                FloatingActionButton(
                  heroTag: "NewPosts",
                  backgroundColor: Colors.lightGreen.shade300,
                  mini: true,
                  child: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Get.to(PostWritePage());
                    if (result != null && result) {
                      c.reload();
                    }
                  },
                ),
              Spacer(),
            ]),
          ),
          Stack(children: [
            SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                child: isNotice
                    ? Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: c.noticeList
                            .map((element) => PostCardItem(info: element))
                            .toList()))
                    : Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: c.postList
                            .map((element) => PostCardItem(info: element))
                            .toList()))),
            SizedBox(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                    colors: <Color>[
                      Colors.lightGreen.shade50.withOpacity(1),
                      Colors.lightGreen.shade50.withOpacity(0)
                    ],
                  ),
                ),
              ),
              width: 40,
              height: 320,
            ),
            Container(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                        colors: <Color>[
                          Colors.lightGreen.shade50.withOpacity(0),
                          Colors.lightGreen.shade50.withOpacity(1)
                        ],
                      ),
                    ),
                  ),
                  width: 40,
                  height: 320,
                ))
          ]),
        ]));
  }
}
