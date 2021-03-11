import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/PushPromotionPage.dart';
import 'package:good_place_camp/Widget/Pages/CampListPage.dart';

// Model
import 'package:good_place_camp/Model/CampArea.dart';

class GPCAppBar extends AppBar {
  final String pageName;
  final bool showFilter;
  final bool isMain;

  GPCAppBar({this.pageName, this.showFilter, this.isMain = false})
      : super(
            centerTitle: true,
            backgroundColor: Colors.lightGreen.shade400,
            title: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                child: Row(children: <Widget>[
                  if (isMain)
                    IconButton(
                      icon: Image.asset('assets/Camp_Main.png'),
                      iconSize: 35,
                      onPressed: () {
                        final HomeController c = Get.find();
                        c.reload();
                      },
                    ),
                  Text(
                    pageName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  Spacer(),
                  if (showFilter)
                    PopupMenuButton<CampArea>(
                      tooltip: "지역필터",
                      icon: Icon(IconData(0xe73d, fontFamily: 'MaterialIcons')),
                      itemBuilder: (context) {
                        return [
                          CheckedPopupMenuItem(
                            value: CampArea.all,
                            checked: Constants.selectedArea.isEmpty,
                            child: Text(
                              CampArea.all.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.seoul,
                            checked:
                                Constants.selectedArea.contains(CampArea.seoul),
                            child: Text(
                              CampArea.seoul.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.gyeonggi,
                            checked: Constants.selectedArea
                                .contains(CampArea.gyeonggi),
                            child: Text(
                              CampArea.gyeonggi.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.inchoen,
                            checked: Constants.selectedArea
                                .contains(CampArea.inchoen),
                            child: Text(
                              CampArea.inchoen.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.chungnam,
                            checked: Constants.selectedArea
                                .contains(CampArea.chungnam),
                            child: Text(
                              CampArea.chungnam.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.chungbuk,
                            checked: Constants.selectedArea
                                .contains(CampArea.chungbuk),
                            child: Text(
                              CampArea.chungbuk.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.gangwon,
                            checked: Constants.selectedArea
                                .contains(CampArea.gangwon),
                            child: Text(
                              CampArea.gangwon.toAreaString(),
                            ),
                          ),
                        ];
                      },
                      onSelected: (area) => onSelected(area),
                    ),
                  if (isMain) ...[
                    SizedBox(width: 20),
                    IconButton(
                      tooltip: "즐겨찾기",
                      icon: const Icon(Icons.star),
                      onPressed: () {
                        Get.to(CampListPage(isFavoritePage: true));
                      },
                      // tooltip: "알림 설정",
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      tooltip: "알림 설정",
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        Get.to(PushPromotionPage());
                      },
                      // tooltip: "알림 설정",
                    ),
                  ]
                ])));

  static void onSelected(CampArea area) {
    final HomeController c = Get.find();

    switch (area) {
      case CampArea.all:
        Constants.selectedArea.clear();
        break;
      default:
        if (Constants.selectedArea.contains(area)) {
          Constants.selectedArea.remove(area);
        } else {
          Constants.selectedArea.add(area);
        }
        break;
    }

    saveCampAreaData(Constants.selectedArea);

    c.reload();
  }
}
