import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
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

enum GPCAppBarMenu { favorite, push, account }

extension GPCAppBarMenuParse on GPCAppBarMenu {
  String toTitle() {
    switch (this) {
      case GPCAppBarMenu.favorite:
        return "favorite".tr();
      case GPCAppBarMenu.push:
        return "notification_setting".tr();
      case GPCAppBarMenu.account:
        return "user_info".tr();
      default:
        return "";
    }
  }
}

class GPCAppBar extends AppBar {
  final String pageName;
  final bool showFilter;
  final bool isMain;

  GPCAppBar({required this.pageName, required this.showFilter, this.isMain = false})
      : super(
            centerTitle: true,
            backgroundColor: Colors.lightGreen.shade400,
            title: Container(
                alignment: Alignment.center,
                padding: Constants.isPhoneSize
                    ? EdgeInsets.zero
                    : EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                  if (Constants.isPhoneSize) ...[
                    if (showFilter) _buildAreaFilter(),
                    SizedBox(width: 20),
                    PopupMenuButton<GPCAppBarMenu>(
                      color: Colors.lightGreen[50],
                      padding: EdgeInsets.zero,
                      onSelected: (menu) {
                        switch (menu) {
                          case GPCAppBarMenu.favorite:
                            _gotoFavoritePage();
                            break;
                          case GPCAppBarMenu.push:
                            _gotoPushPage();
                            break;
                          case GPCAppBarMenu.account:
                            _gotoAccountPage();
                            break;
                          default:
                        }
                      },
                      itemBuilder: (context) => <PopupMenuItem<GPCAppBarMenu>>[
                        if (Constants.user.value.isLogin)
                          PopupMenuItem<GPCAppBarMenu>(
                            enabled: false,
                            child: Text("dear").tr(args: [Constants.user.value.info.nick ?? ""]),
                          ),
                        PopupMenuItem<GPCAppBarMenu>(
                          value: GPCAppBarMenu.favorite,
                          child: Row(children: [
                            Icon(
                              Icons.star,
                              color: Colors.lightGreen,
                            ),
                            SizedBox(width: 10),
                            Text(
                              GPCAppBarMenu.favorite.toTitle(),
                            )
                          ]),
                        ),
                        PopupMenuItem<GPCAppBarMenu>(
                          value: GPCAppBarMenu.push,
                          child: Row(children: [
                            Icon(
                              Icons.notifications,
                              color: Colors.lightGreen,
                            ),
                            SizedBox(width: 10),
                            Text(
                              GPCAppBarMenu.push.toTitle(),
                            )
                          ]),
                        ),
                        PopupMenuItem<GPCAppBarMenu>(
                          value: GPCAppBarMenu.account,
                          child: Row(children: [
                            Icon(
                              Icons.account_circle,
                              color: Colors.lightGreen,
                            ),
                            SizedBox(width: 10),
                            Text(
                              GPCAppBarMenu.account.toTitle(),
                            )
                          ]),
                        ),
                      ],
                    )
                  ] else ...[
                    Obx(() => Text(Constants.user.value.isLogin
                        ? "dear".tr(args: [Constants.user.value.info.nick ?? ""])
                        : "")),
                    SizedBox(width: 20),
                    if (showFilter) _buildAreaFilter(),
                    if (isMain) ...[
                      SizedBox(width: 20),
                      IconButton(
                        tooltip: GPCAppBarMenu.favorite.toTitle(),
                        icon: Icon(Icons.star),
                        onPressed: _gotoFavoritePage,
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        tooltip: GPCAppBarMenu.push.toTitle(),
                        icon: Icon(Icons.notifications),
                        onPressed: _gotoPushPage,
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        tooltip: GPCAppBarMenu.account.toTitle(),
                        icon: Icon(Icons.account_circle),
                        onPressed: _gotoAccountPage,
                      ),
                    ]
                  ]
                ])));

  static Widget _buildAreaFilter() {
    return PopupMenuButton<CampArea>(
      tooltip: "notification_filter_region".tr(),
      color: Colors.lightGreen[50],
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
            checked: Constants.myArea.contains(CampArea.gyeonggi),
            child: Text(
              CampArea.gyeonggi.toAreaString(),
            ),
          ),
          CheckedPopupMenuItem(
            value: CampArea.inchoen,
            checked: Constants.myArea.contains(CampArea.inchoen),
            child: Text(
              CampArea.inchoen.toAreaString(),
            ),
          ),
          CheckedPopupMenuItem(
            value: CampArea.chungnam,
            checked: Constants.myArea.contains(CampArea.chungnam),
            child: Text(
              CampArea.chungnam.toAreaString(),
            ),
          ),
          CheckedPopupMenuItem(
            value: CampArea.chungbuk,
            checked: Constants.myArea.contains(CampArea.chungbuk),
            child: Text(
              CampArea.chungbuk.toAreaString(),
            ),
          ),
          CheckedPopupMenuItem(
            value: CampArea.gangwon,
            checked: Constants.myArea.contains(CampArea.gangwon),
            child: Text(
              CampArea.gangwon.toAreaString(),
            ),
          ),
        ];
      },
      onSelected: (area) => onSelected(area),
    );
  }

  static void onSelected(CampArea area) async {
    final HomeController c = Get.find();
    SharedPreferences prefs = await SharedPreferences.getInstance();

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

        if (Constants.myArea.length > 0) {
          final bit = Constants.myArea
                  .map((element) => element.toBit())
                  .reduce((value, element) => value + element);
          prefs.setInt(MY_AREA_BIT_KEY, bit);
        } else {
          prefs.setInt(MY_AREA_BIT_KEY, 0);
        }

        break;
    }

    c.reload();
  }

  static void _gotoFavoritePage() {
    if (!Constants.user.value.isLogin) {
      showRequiredLoginAlert();
    } else {
      Get.to(CampListPage(isFavoritePage: true));
    }
  }

  static void _gotoPushPage() {
    Get.to(PushPromotionPage());
  }

  static void _gotoAccountPage() {
    if (!Constants.user.value.isLogin) {
      showRequiredLoginAlert();
    } else {
      Get.to(UserInfoPage());
    }
  }
}
