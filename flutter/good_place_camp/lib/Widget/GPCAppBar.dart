import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

class GPCAppBar extends AppBar {
  final HomeController c = Get.find();

  GPCAppBar()
      : super(
            backgroundColor: Colors.lightGreen.shade500,
            title: Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                child: Row(children: <Widget>[
                  Text("명당캠핑"),
                  Spacer(),
                  PopupMenuButton<String>(
                    icon: Icon(IconData(0xe73d, fontFamily: 'MaterialIcons')),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text(
                            "First",
                          ),
                        ),
                        PopupMenuItem(
                          child: Text(
                            "Second",
                          ),
                        ),
                        PopupMenuItem(
                          child: Text(
                            "Third",
                          ),
                        ),
                      ];
                    },
                  )
                ]))) {}
}
