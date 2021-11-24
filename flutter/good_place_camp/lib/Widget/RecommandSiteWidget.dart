import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:flutter/cupertino.dart';

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
                  Text("recommend_site",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 26))
                      .tr(),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    heroTag: "RecommandSite",
                    backgroundColor: Colors.lightGreen.shade300,
                    mini: true,
                    child: const Icon(Icons.list),
                    onPressed: () {
                      Navigator.push<void>(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => CampListPage(),
                          ));
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
                        children: [
                          for (final widget in _recommandSiteCardWidgets(
                              c.accpetedCampInfo.map((e) => e.key)))
                            widget,
                          IconButton(
                            iconSize: 50,
                            color: Colors.lightGreen.shade300,
                            icon: Icon(Icons.more_horiz),
                            onPressed: () {
                              Navigator.push<void>(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => CampListPage(),
                                  ));
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

  Iterable<Widget> _recommandSiteCardWidgets(Iterable<String> siteKeys) {
    var keyList = siteKeys.toList();
    keyList.shuffle();
    keyList.length = keyList.length > 5 ? 5 : keyList.length;
    return keyList.map((key) => SimpleCampCardItem(siteName: key));
  }
}
