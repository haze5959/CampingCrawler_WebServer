import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/Cards/SimpleCampCardItem.dart';
import 'package:good_place_camp/Widget/Pages/CampListPage.dart';

class RecommandSiteWidget extends StatelessWidget {
  // final bool isVertical;

  // RecommandSiteWidget({this.isVertical});

  @override
  Widget build(context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
        child: Row(children: [
          Text("추천 명당",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
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
                      pageBuilder: (BuildContext context, Animation animation,
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
      SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: CAMP_INFO.keys
                  .map((key) => SimpleCampCardItem(siteName: key))
                  .toList())),
    ]);
  }
}
