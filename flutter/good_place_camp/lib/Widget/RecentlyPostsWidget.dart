import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/Cards/PostCardItem.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class RecentlyPostsWidget extends StatelessWidget {
  // final bool isVertical;

  // RecentlyPostsWidget({this.isVertical});

  @override
  Widget build(context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
        child: Row(children: [
          Text("게시판",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              textAlign: TextAlign.left),
          SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "RecentlyPosts",
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
                  .map((key) => PostCardItem(
                          info: Post(
                        "타이을",
                        "바디들",
                        "으허허헝",
                      )))
                  .toList())),
    ]);
  }
}
