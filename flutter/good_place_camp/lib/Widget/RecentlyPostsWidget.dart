import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:get/get.dart';

// Widgets
import 'package:good_place_camp/Widget/Cards/PostCardItem.dart';
import 'package:good_place_camp/Widget/Pages/PostListPage.dart';

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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  textAlign: TextAlign.left),
              SizedBox(width: 10),
              FloatingActionButton(
                heroTag: isNotice ? "RecentlyNoticePosts" : "RecentlyPosts",
                backgroundColor: Colors.lightGreen.shade300,
                mini: true,
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push<void>(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (BuildContext context,
                              Animation animation,
                              Animation secondaryAnimation) {
                            return PostListPage(isNotice: isNotice);
                          },
                          opaque: true,
                          barrierColor: Colors.grey,
                          transitionDuration: Duration(milliseconds: 300),
                          transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: new Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          }));
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
