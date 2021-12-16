import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        return "favorite".tr;
      case GPCAppBarMenu.push:
        return "notification_setting".tr;
      case GPCAppBarMenu.account:
        return "user_info".tr;
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
            backgroundColor: Colors.lightGreen.shade400,
            automaticallyImplyLeading: !isMain,
            leading: isMain
                ? null
                : Row(
                    children: [
                      const BackButton(),
                      const SizedBox(width: 10),
                      homeIcon
                    ],
                  ),
            leadingWidth: isMain ? 0 : 120,
            title: Row(children: <Widget>[
              if (isMain) ...[
                if (!Constants.isPhoneSize) const SizedBox(width: 15),
                mainIcon,
                Text(
                  pageName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 26),
                ),
                const Spacer()
              ] else ...[
                Text(
                  pageName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 26),
                )
              ]
            ]),
            actions: [
              if (Constants.isPhoneSize) ...[
                if (showFilter) _buildAreaFilter(),
                const SizedBox(width: 10),
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
                        child: Text("dear".trParams(
                            {"dear": Constants.user.value.info.nick ?? ""})),
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
                    ? "dear".trParams(
                        {"dear": Constants.user.value.info.nick ?? ""})
                    : "")),
                const SizedBox(width: 10),
                if (showFilter) _buildAreaFilter(),
                if (isMain) ...[
                  const SizedBox(width: 10),
                  IconButton(
                    tooltip: GPCAppBarMenu.favorite.toTitle(),
                    icon: const Icon(Icons.star),
                    onPressed: _gotoFavoritePage,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    tooltip: GPCAppBarMenu.push.toTitle(),
                    icon: const Icon(Icons.notifications),
                    onPressed: _gotoPushPage,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    tooltip: GPCAppBarMenu.account.toTitle(),
                    icon: const Icon(Icons.account_circle),
                    onPressed: _gotoAccountPage,
                  ),
                  const SizedBox(width: 15),
                ]
              ]
            ]);

  static Widget _buildAreaFilter() {
    return IconButton(
      tooltip: "notification_filter_region".tr,
      icon: const Icon(Icons.filter_list_rounded),
      onPressed: showAreaFilterDialog,
    );
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

  static IconButton mainIcon = IconButton(
    icon: Image.asset('assets/Camp_Main.png'),
    iconSize: 35,
    onPressed: () {
      final HomeController c = Get.find();
      c.reload();
    },
  );

  static IconButton homeIcon = IconButton(
    icon: Image.asset('assets/Camp_Main.png'),
    iconSize: 35,
    onPressed: () {
      Get.toNamed("/");
    },
  );
}
