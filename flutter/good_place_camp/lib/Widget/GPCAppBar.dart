import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

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

  GPCAppBar(
      {required this.pageName, required this.showFilter, this.isMain = false})
      : super(
            centerTitle: true,
            backgroundColor: Colors.lightGreen.shade400,
            title: Container(
                alignment: Alignment.center,
                padding: Constants.isPhoneSize
                    ? EdgeInsets.zero
                    : const EdgeInsets.fromLTRB(15, 0, 15, 0),
                constraints: const BoxConstraints(maxWidth: MAX_WIDTH),
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
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  const Spacer(),
                  if (Constants.isPhoneSize) ...[
                    if (showFilter) _buildAreaFilter(),
                    const SizedBox(width: 20),
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
                            child: const Text("dear").tr(
                                args: [Constants.user.value.info.nick ?? ""]),
                          ),
                        PopupMenuItem<GPCAppBarMenu>(
                          value: GPCAppBarMenu.favorite,
                          child: Row(children: [
                            const Icon(
                              Icons.star,
                              color: Colors.lightGreen,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              GPCAppBarMenu.favorite.toTitle(),
                            )
                          ]),
                        ),
                        PopupMenuItem<GPCAppBarMenu>(
                          value: GPCAppBarMenu.push,
                          child: Row(children: [
                            const Icon(
                              Icons.notifications,
                              color: Colors.lightGreen,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              GPCAppBarMenu.push.toTitle(),
                            )
                          ]),
                        ),
                        PopupMenuItem<GPCAppBarMenu>(
                          value: GPCAppBarMenu.account,
                          child: Row(children: [
                            const Icon(
                              Icons.account_circle,
                              color: Colors.lightGreen,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              GPCAppBarMenu.account.toTitle(),
                            )
                          ]),
                        ),
                      ],
                    )
                  ] else ...[
                    // 폰사이즈가 아닐 경우
                    Obx(() => Text(Constants.user.value.isLogin
                        ? "dear"
                            .tr(args: [Constants.user.value.info.nick ?? ""])
                        : "")),
                    const SizedBox(width: 20),
                    if (showFilter) _buildAreaFilter(),
                    if (isMain) ...[
                      const SizedBox(width: 20),
                      IconButton(
                        tooltip: GPCAppBarMenu.favorite.toTitle(),
                        icon: const Icon(Icons.star),
                        onPressed: _gotoFavoritePage,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        tooltip: GPCAppBarMenu.push.toTitle(),
                        icon: const Icon(Icons.notifications),
                        onPressed: _gotoPushPage,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        tooltip: GPCAppBarMenu.account.toTitle(),
                        icon: const Icon(Icons.account_circle),
                        onPressed: _gotoAccountPage,
                      ),
                    ]
                  ]
                ])));

  static Widget _buildAreaFilter() {
    return IconButton(
      tooltip: "notification_filter_region".tr(),
      icon: const Icon(Icons.filter_list_rounded),
      onPressed: showAreaFilterDialog,
    );

    // return PopupMenuButton<CampArea>(
    //   tooltip: "notification_filter_region".tr(),
    //   color: Colors.lightGreen[50],
    //   child: Row(children: [
    //     const Text("이거 보이냥아아"),
    //     const SizedBox(width: 10),
    //     const Icon(Icons.filter_list_rounded)
    //   ]),
    //   itemBuilder: (context) {
    //     return [
    //       for (final area in CampArea.values)
    //         CheckedPopupMenuItem(
    //           value: area,
    //           checked: Constants.myArea.contains(area),
    //           child: Text(
    //             area.toAreaString(),
    //           ),
    //         ),
    //     ];
    //   },
    //   onSelected: (area) => onSelected(area),
    // );
  }

  static void onSelected(CampArea area) async {
    final HomeController c = Get.find();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (Constants.myArea.contains(area)) {
      Constants.myArea.remove(area);
    } else {
      Constants.myArea.add(area);
    }

    if (Constants.myArea.length > 0) {
      final bit = toAreaBit(Constants.myArea);
      prefs.setInt(MY_AREA_BIT_KEY, bit);
    } else {
      prefs.setInt(MY_AREA_BIT_KEY, 0);
    }

    c.reload();
  }

  static void _gotoFavoritePage() {
    if (!Constants.user.value.isLogin) {
      showRequiredLoginAlert();
    } else {
      Get.toNamed("/camp/list", parameters: {"is_favorite": "true"});
    }
  }

  static void _gotoPushPage() {
    Get.toNamed("/promotion");
  }

  static void _gotoAccountPage() {
    if (!Constants.user.value.isLogin) {
      showRequiredLoginAlert();
    } else {
      Get.toNamed("/myinfo");
    }
  }
}
