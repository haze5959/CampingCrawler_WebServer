import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/Cards/SimpleCampCardItem.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

class RecommandSiteWidget extends StatelessWidget {
  final _scrollController = ScrollController();
  final _showLeftBtn = false.obs;
  final _showRightBtn = true.obs;

  @override
  Widget build(context) {
    return GetBuilder<HomeController>(
        builder: (c) => Container(
            constraints: BoxConstraints(maxWidth: HORIZE_INFO_MAX_WIDTH),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 15),
                child: Row(children: [
                  Text("recommend_site".tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 26)),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    heroTag: "RecommandSite",
                    backgroundColor: Colors.lightGreen.shade300,
                    mini: true,
                    child: const Icon(Icons.list),
                    onPressed: () {
                      Get.toNamed("/camp/list");
                    },
                  ),
                  const Spacer(),
                ]),
              ),
              Stack(children: [
                SizedBox(
                    height: CARD_HEIGHT,
                    child: NotificationListener(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          itemCount: c.accpetedCampInfo.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: CARD_SPACE,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return SimpleCampCardItem(
                                siteName: c.accpetedCampInfo[index].key);
                          },
                        ),
                        onNotification: (t) {
                          if (t is ScrollNotification) {
                            final metrics = t.metrics;
                            if (metrics.atEdge) {
                              if (metrics.pixels == 0) {
                                _showLeftBtn.value = false;
                              } else {
                                _showRightBtn.value = false;
                              }
                            } else {
                              _showLeftBtn.value = true;
                              _showRightBtn.value = true;
                            }
                          }

                          return true;
                        })),
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
                  width: 60,
                  height: CARD_HEIGHT,
                ),
                Container(
                    height: CARD_HEIGHT,
                    padding: const EdgeInsets.only(left: 20),
                    child: Obx(() => Visibility(
                          child: FloatingActionButton(
                              heroTag: "RecommandSite_left",
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white.withOpacity(0.7),
                              mini: true,
                              child: Icon(Icons.chevron_left),
                              onPressed: () {
                                final offset =
                                    _scrollController.position.pixels -
                                        CARD_WIDTH -
                                        CARD_SPACE;
                                _scrollController.animateTo(offset,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut);
                              }),
                          visible: _showLeftBtn.value,
                        ))),
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
                      width: 60,
                      height: CARD_HEIGHT,
                    )),
                Container(
                    height: CARD_HEIGHT,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: Obx(() => Visibility(
                          child: FloatingActionButton(
                              heroTag: "RecommandSite_right",
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white.withOpacity(0.7),
                              mini: true,
                              child: Icon(Icons.chevron_right),
                              onPressed: () {
                                final offset =
                                    _scrollController.position.pixels +
                                        CARD_WIDTH +
                                        CARD_SPACE;
                                _scrollController.animateTo(offset,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut);
                              }),
                          visible: _showRightBtn.value,
                        ))),
              ]),
            ])));
  }
}
