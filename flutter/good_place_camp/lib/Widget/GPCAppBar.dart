import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Model
import 'package:good_place_camp/Model/CampArea.dart';

class GPCAppBar extends AppBar {
  final String pageName;
  final bool showFilter;

  GPCAppBar({this.pageName, this.showFilter})
      : super(
            backgroundColor: Colors.lightGreen.shade500,
            title: Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                child: Row(children: <Widget>[
                  Text(pageName),
                  Spacer(),
                  if (showFilter)
                    PopupMenuButton<CampArea>(
                      tooltip: "지역필터",
                      icon: Icon(IconData(0xe73d, fontFamily: 'MaterialIcons')),
                      itemBuilder: (context) {
                        return [
                          CheckedPopupMenuItem(
                            value: CampArea.all,
                            checked: SELECTED_AREA.isEmpty,
                            child: Text(
                              CampArea.all.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.seoul,
                            checked: SELECTED_AREA.contains(CampArea.seoul),
                            child: Text(
                              CampArea.seoul.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.gyeonggi,
                            checked: SELECTED_AREA.contains(CampArea.gyeonggi),
                            child: Text(
                              CampArea.gyeonggi.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.inchoen,
                            checked: SELECTED_AREA.contains(CampArea.inchoen),
                            child: Text(
                              CampArea.inchoen.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.chungnam,
                            checked: SELECTED_AREA.contains(CampArea.chungnam),
                            child: Text(
                              CampArea.chungnam.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.chungbuk,
                            checked: SELECTED_AREA.contains(CampArea.chungbuk),
                            child: Text(
                              CampArea.chungbuk.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.gangwon,
                            checked: SELECTED_AREA.contains(CampArea.gangwon),
                            child: Text(
                              CampArea.gangwon.toAreaString(),
                            ),
                          ),
                        ];
                      },
                      onSelected: (area) => onSelected(area),
                    )
                ]))) {}

  static void onSelected(CampArea area) {
    final HomeController c = Get.find();

    switch (area) {
      case CampArea.all:
        SELECTED_AREA.clear();
        break;
      default:
        if (SELECTED_AREA.contains(area)) {
          SELECTED_AREA.remove(area);
        } else {
          SELECTED_AREA.add(area);
        }
        break;
    }

    c.reload();
  }
}
