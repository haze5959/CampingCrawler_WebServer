import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:get/get.dart';

// Widgets
import 'package:good_place_camp/Widget/Cards/PostCardItem.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

class RecentlyPostsWidget extends StatelessWidget {
  final bool isNotice; // 공지사항 뷰인지
  final _scrollController = ScrollController();
  final _showLeftBtn = false.obs;
  final _showRightBtn = true.obs;

  RecentlyPostsWidget({required this.isNotice});

  @override
  Widget build(context) {
    return GetBuilder<HomeController>(
        builder: (c) => Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            constraints: const BoxConstraints(maxWidth: HORIZE_INFO_MAX_WIDTH),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 15),
                child: Row(children: [
                  Text(
                      isNotice
                          ? "board_notice_event".tr
                          : "board_request_question".tr,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    heroTag: isNotice ? "RecentlyNoticePosts" : "RecentlyPosts",
                    backgroundColor: Colors.lightGreen.shade300,
                    mini: true,
                    child: const Icon(Icons.list),
                    onPressed: () async {
                      _goDetail(c);
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
                SizedBox(
                    height: POSTS_CARD_HEIGHT,
                    child: NotificationListener(
                        child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            itemCount: (isNotice
                                    ? c.noticeList.length
                                    : c.postList.length) +
                                1,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                width: CARD_SPACE,
                              );
                            },
                            itemBuilder: (BuildContext context, int index) {
                              final list = isNotice ? c.noticeList : c.postList;
                              if (index < list.length) {
                                return PostCardItem(list[index]);
                              } else {
                                return _seeMoreWidget(c);
                              }
                            }),
                        onNotification: (t) {
                          if (t is ScrollMetricsNotification) {
                            // 스크롤이 그려졌을 때
                            final metrics = t.metrics;
                            if (metrics.extentBefore == 0) {
                              _showLeftBtn.value = false;
                            } else {
                              _showLeftBtn.value = true;
                            }

                            if (metrics.extentAfter == 0) {
                              _showRightBtn.value = false;
                            } else {
                              _showRightBtn.value = true;
                            }
                          }

                          return true;
                        })),
                IgnorePointer(
                    child: SizedBox(
                        width: 60,
                        height: POSTS_CARD_HEIGHT,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: new LinearGradient(
                              colors: <Color>[
                                Colors.lightGreen.shade50.withOpacity(1),
                                Colors.lightGreen.shade50.withOpacity(0)
                              ],
                            ),
                          ),
                        ))),
                Container(
                    height: POSTS_CARD_HEIGHT,
                    padding: const EdgeInsets.only(left: 20),
                    child: Obx(() => Visibility(
                          child: FloatingActionButton(
                              heroTag: isNotice
                                  ? "RecentlyNoticePosts_left"
                                  : "RecentlyPosts_left",
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white.withOpacity(0.7),
                              mini: true,
                              child: Icon(Icons.chevron_left),
                              onPressed: () {
                                _scrollController.animateTo(
                                    _getAmountOfScroll(false),
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut);
                              }),
                          visible: _showLeftBtn.value,
                        ))),
                IgnorePointer(
                    child: Container(
                        width: 60,
                        height: POSTS_CARD_HEIGHT,
                        alignment: Alignment.centerRight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: new LinearGradient(
                              colors: <Color>[
                                Colors.lightGreen.shade50.withOpacity(0),
                                Colors.lightGreen.shade50.withOpacity(1)
                              ],
                            ),
                          ),
                        ))),
                Container(
                    height: POSTS_CARD_HEIGHT,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: Obx(() => Visibility(
                          child: FloatingActionButton(
                              heroTag: isNotice
                                  ? "RecentlyNoticePosts_right"
                                  : "RecentlyPosts_right",
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white.withOpacity(0.7),
                              mini: true,
                              child: Icon(Icons.chevron_right),
                              onPressed: () {
                                _scrollController.animateTo(
                                    _getAmountOfScroll(true),
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut);
                              }),
                          visible: _showRightBtn.value,
                        ))),
              ]),
            ])));
  }

  void _goDetail(HomeController c) async {
    await Get.toNamed("/board/list",
        parameters: {"is_notice": isNotice ? "true" : "false"});
    c.reload();
  }

  double _getAmountOfScroll(bool isRight) {
    var scrollFrameWidth = Get.size.width;
    if (scrollFrameWidth > HORIZE_INFO_MAX_WIDTH) {
      scrollFrameWidth = HORIZE_INFO_MAX_WIDTH;
    }

    final cardScrollSpace = CARD_WIDTH + CARD_SPACE;
    final scrollCount = scrollFrameWidth / cardScrollSpace;
    final extraAmount = _scrollController.position.pixels % cardScrollSpace;

    if (isRight) {
      final offset = _scrollController.position.pixels +
          (cardScrollSpace * scrollCount) -
          CARD_SPACE -
          extraAmount;
      final endOffset = _scrollController.position.pixels +
          _scrollController.position.extentAfter;

      if (offset > endOffset) {
        return endOffset;
      } else {
        return offset;
      }
    } else {
      final offset = _scrollController.position.pixels -
          (cardScrollSpace * scrollCount) +
          CARD_SPACE -
          extraAmount;

      if (offset < 0) {
        return 0;
      } else {
        return offset;
      }
    }
  }

  Widget _seeMoreWidget(HomeController c) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Center(
            child: TextButton(
                style: TextButton.styleFrom(onSurface: Colors.red),
                onPressed: () {
                  _goDetail(c);
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          child:
                              Icon(Icons.arrow_forward, color: Colors.black)),
                      SizedBox(height: 10),
                      Text("more".tr, style: TextStyle(color: Colors.black))
                    ]))));
  }
}
