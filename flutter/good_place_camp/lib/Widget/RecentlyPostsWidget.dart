import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

// Widgets
import 'package:good_place_camp/Widget/Cards/PostCardItem.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

class RecentlyPostsWidget extends StatelessWidget {
  final bool isNotice; // 공지사항 뷰인지

  RecentlyPostsWidget({required this.isNotice});

  @override
  Widget build(context) {
    return GetBuilder<HomeController>(
        builder: (c) => Container(
            constraints: const BoxConstraints(maxWidth: MAX_WIDTH),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Row(children: [
                  Text(
                      isNotice
                          ? "board_notice_event".tr()
                          : "board_request_question".tr(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    heroTag: isNotice ? "RecentlyNoticePosts" : "RecentlyPosts",
                    backgroundColor: Colors.lightGreen.shade300,
                    mini: true,
                    child: const Icon(Icons.list),
                    onPressed: () async {
                      await Get.toNamed("/board/list", parameters: {
                        "is_notice": isNotice ? "true" : "false"
                      });
                      c.reload();
                    },
                  ),
                  const SizedBox(width: 10),
                  if (!isNotice)
                    FloatingActionButton(
                      heroTag: "NewPosts",
                      backgroundColor: Colors.lightGreen.shade300,
                      mini: true,
                      child: const Icon(Icons.edit),
                      onPressed: () async {
                        bool result = await Get.toNamed("/board/write");
                        if (result) {
                          c.reload();
                        }
                      },
                    ),
                  const Spacer(),
                ]),
              ),
              Stack(children: [
                SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (final item
                              in isNotice ? c.noticeList : c.postList)
                            PostCardItem(item),
                          IconButton(
                            iconSize: 50,
                            color: Colors.lightGreen.shade300,
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              Get.toNamed("/board/list", parameters: {
                                "is_notice": isNotice ? "true" : "false"
                              });
                            },
                          )
                        ])),
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
            ])));
  }
}
