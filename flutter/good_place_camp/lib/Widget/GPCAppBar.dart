import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/PushPromotionPage.dart';
import 'package:good_place_camp/Widget/Pages/CampListPage.dart';
import 'package:good_place_camp/Widget/Pages/UserInfoPage.dart';

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
                padding: GetPlatform.isWeb
                    ? EdgeInsets.fromLTRB(15, 0, 15, 0)
                    : EdgeInsets.zero,
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
                  if (!Constants.isPhoneSize) ...[
                    Obx(() => Text(Constants.user.value.isLogin
                        ? "${Constants.user.value.info.nick} 님"
                        : "")),
                    SizedBox(width: GetPlatform.isWeb ? 20 : 0),
                  ],
                  if (showFilter)
                    PopupMenuButton<CampArea>(
                      tooltip: "지역필터",
                      icon: Icon(Icons.filter_list_rounded),
                      itemBuilder: (context) {
                        return [
                          CheckedPopupMenuItem(
                            value: CampArea.all,
                            checked: Constants.myArea.isEmpty,
                            child: Text(
                              CampArea.all.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.seoul,
                            checked: Constants.myArea.contains(CampArea.seoul),
                            child: Text(
                              CampArea.seoul.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.gyeonggi,
                            checked:
                                Constants.myArea.contains(CampArea.gyeonggi),
                            child: Text(
                              CampArea.gyeonggi.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.inchoen,
                            checked:
                                Constants.myArea.contains(CampArea.inchoen),
                            child: Text(
                              CampArea.inchoen.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.chungnam,
                            checked:
                                Constants.myArea.contains(CampArea.chungnam),
                            child: Text(
                              CampArea.chungnam.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.chungbuk,
                            checked:
                                Constants.myArea.contains(CampArea.chungbuk),
                            child: Text(
                              CampArea.chungbuk.toAreaString(),
                            ),
                          ),
                          CheckedPopupMenuItem(
                            value: CampArea.gangwon,
                            checked:
                                Constants.myArea.contains(CampArea.gangwon),
                            child: Text(
                              CampArea.gangwon.toAreaString(),
                            ),
                          ),
                        ];
                      },
                      onSelected: (area) => onSelected(area),
                    ),
                  if (isMain) ...[
                    SizedBox(width: GetPlatform.isWeb ? 20 : 0),
                    IconButton(
                      tooltip: "즐겨찾기",
                      icon: const Icon(Icons.star),
                      onPressed: () {
                        if (!Constants.user.value.isLogin) {
                          showRequiredLoginAlert();
                        } else {
                          Get.to(CampListPage(isFavoritePage: true));
                        }
                      },
                      // tooltip: "알림 설정",
                    ),
                    SizedBox(width: GetPlatform.isWeb ? 20 : 0),
                    IconButton(
                      tooltip: "알림 설정",
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        Get.to(PushPromotionPage());
                      },
                      // tooltip: "알림 설정",
                    ),
                    SizedBox(width: GetPlatform.isWeb ? 20 : 0),
                    IconButton(
                      tooltip: "계정 정보",
                      icon: const Icon(Icons.account_circle),
                      onPressed: () {
                        if (!Constants.user.value.isLogin) {
                          showRequiredLoginAlert();
                        } else {
                          Get.to(UserInfoPage());
                        }
                      },
                      // tooltip: "알림 설정",
                    ),
                  ]
                ])));

  static void onSelected(CampArea area) async {
    final HomeController c = Get.find();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(area);
    switch (area) {
      case CampArea.all:
        Constants.myArea.clear();
        prefs.setInt(MY_AREA_BIT_KEY, 0);
        break;
      default:
        if (Constants.myArea.contains(area)) {
          Constants.myArea.remove(area);
        } else {
          Constants.myArea.add(area);
        }

        final bit = Constants.myArea
            .map((element) => element.toBit())
            .reduce((value, element) => value + element);
        prefs.setInt(MY_AREA_BIT_KEY, bit);
        break;
    }

    c.reload();
  }
}
