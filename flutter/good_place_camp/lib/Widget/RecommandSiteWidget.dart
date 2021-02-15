import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/Cards/SimpleCampCardItem.dart';

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
            backgroundColor: Colors.lightGreen.shade300,
            mini: true,
            child: const Icon(Icons.add),
            onPressed: () {},
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
