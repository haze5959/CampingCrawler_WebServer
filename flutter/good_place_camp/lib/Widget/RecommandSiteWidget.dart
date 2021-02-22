import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/Cards/SimpleCampCardItem.dart';
import 'package:good_place_camp/Widget/Pages/CampListPage.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

class RecommandSiteWidget extends StatelessWidget {
  @override
  Widget build(context) {
    return GetBuilder<HomeController>(
        builder: (c) => Container(
            constraints: BoxConstraints(maxWidth: MAX_WIDTH),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Row(children: [
                  Text("추천 명당",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                      textAlign: TextAlign.left),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    heroTag: "RecommandSite",
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
                                return CampListPage();
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: c.accpetedCampInfo.keys
                            .map((key) => SimpleCampCardItem(siteName: key))
                            .toList())),
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
