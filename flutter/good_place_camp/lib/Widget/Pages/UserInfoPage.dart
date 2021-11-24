import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Controller
import 'package:good_place_camp/Controller/UserInfoController.dart';

// Models
import 'package:good_place_camp/Model/CampUser.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/PushPromotionPage.dart';

class UserInfoPage extends StatelessWidget {
  final UserInfoController c = UserInfoController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserInfoController>(
        init: c,
        builder: (_) {
          return Scaffold(
              appBar: AppBar(
                title: Text("mypage").tr(),
                actions: [],
              ),
              body: Obx(() => Stack(children: [
                    if (Constants.user.value.isLogin)
                      SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Center(
                            child: Container(
                                constraints: BoxConstraints(maxWidth: 500),
                                child:
                                    _buildInfoContent(Constants.user.value))),
                      ),
                    if (c.isLoading.value)
                      Center(child: CircularProgressIndicator())
                  ])));
        });
  }

  Widget _buildInfoContent(CampUser user) {
    return Column(
      children: [
        SizedBox(height: 50),
        _buildUserInfo(user),
        SizedBox(height: 50),
        _buildSubscriptInfo(user),
        SizedBox(height: 50),
        _buildSNSInfo(user),
        SizedBox(height: 50),
        _buildETCInfo(user),
        SizedBox(height: 50),
      ],
    );
  }

  Widget _buildUserInfo(CampUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text("user_info",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black54))
                .tr()),
        Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              // 닉네임 설정
              Text("nick",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                  .tr(),
              Spacer(),
              OutlinedButton(
                style: OutlinedButton.styleFrom(primary: Colors.black),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(user.info.nick ?? "",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                onPressed: () async {
                  showChangeNickAlert();
                },
              )
            ])),
        SizedBox(height: 20),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              // 레벨
              Text("dialog_grade",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                  .tr(),
              Tooltip(
                  message: "dialog_grade_auth".tr(),
                  child: IconButton(
                    onPressed: () {
                      showRatingInfoAlert();
                    },
                    icon: const Icon(
                      Icons.info,
                    ),
                  )),
              Spacer(),
              Text(user.info.level?.getLevelText() ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
            ]))
      ],
    );
  }

  Widget _buildSubscriptInfo(CampUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text("subscribe_info",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black54))
                .tr()),
        Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              // 구독하러가기 or 푸시설정 바로가기
              if (user.info.usePushSubscription ?? false) ...[
                Text("subscribe_ing",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))
                    .tr(),
                Spacer(),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("notification_setting",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                              .tr()
                        ]),
                  ),
                  onPressed: () async {
                    Get.to(PushPromotionPage());
                  },
                )
              ] else ...[
                Text("subscribe_no_info",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))
                    .tr(),
                Spacer(),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("subscribe_noti",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))
                              .tr()
                        ]),
                  ),
                  onPressed: () async {
                    Get.to(PushPromotionPage());
                  },
                )
              ]
            ]))
      ],
    );
  }

  Widget _buildSNSInfo(CampUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text("login_link_sns",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black54))
                .tr()),
        Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: ImageIcon(AssetImage("assets/ico_google.png"),
                      size: 15, color: Colors.deepOrange[700])),
              Text("login_google_btn",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                  .tr(),
              Spacer(),
              if (c.linkedSNS.contains("google.com")) ...[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("login_link_sns_ing",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))
                        .tr()),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("login_unlink_sns",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                              .tr()
                        ]),
                  ),
                  onPressed: () async {
                    final result = await c.unlinkProvider("google.com");
                    if (result) {
                      c.linkedSNS.remove("google.com");
                    }
                  },
                )
              ] else
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("login_link_sns_start",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                              .tr()
                        ]),
                  ),
                  onPressed: () async {
                    final result = await c.linkWithGoogle();
                    if (result) {
                      c.linkedSNS.add("google.com");
                    }
                  },
                )
            ])),
        SizedBox(height: 20),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: ImageIcon(AssetImage("assets/ico_facebook.png"),
                      size: 15, color: Colors.blue[700])),
              Text("login_facebook_btn",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                  .tr(),
              Spacer(),
              if (c.linkedSNS.contains("facebook.com")) ...[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("login_link_sns_ing",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))
                        .tr()),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("login_unlink_sns",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                              .tr()
                        ]),
                  ),
                  onPressed: () async {
                    final result = await c.unlinkProvider("facebook.com");
                    if (result) {
                      c.linkedSNS.remove("facebook.com");
                    }
                  },
                )
              ] else
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("login_link_sns_start",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                              .tr()
                        ]),
                  ),
                  onPressed: () async {
                    final result = await c.linkWithFacebook();
                    if (result) {
                      c.linkedSNS.add("facebook.com");
                    }
                  },
                )
            ])),
        SizedBox(height: 20),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: ImageIcon(AssetImage("assets/ico_twitter.png"),
                      size: 15, color: Colors.lightBlue[700])),
              Text("login_twitter_btn",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                  .tr(),
              Spacer(),
              if (c.linkedSNS.contains("twitter.com")) ...[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("login_link_sns_ing",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))
                        .tr()),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("login_unlink_sns",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                              .tr()
                        ]),
                  ),
                  onPressed: () async {
                    final result = await c.unlinkProvider("twitter.com");
                    if (result) {
                      c.linkedSNS.remove("twitter.com");
                    }
                  },
                )
              ] else
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("login_link_sns_start",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                              .tr()
                        ]),
                  ),
                  onPressed: () async {
                    final result = await c.linkWithFacebook();
                    if (result) {
                      c.linkedSNS.add("facebook.com");
                    }
                  },
                )
            ])),
        SizedBox(height: 20),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: ImageIcon(AssetImage("assets/ico_apple.png"),
                      size: 15, color: Colors.black)),
              Text("login_apple_btn",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                  .tr(),
              Spacer(),
              if (c.linkedSNS.contains("apple.com")) ...[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("login_link_sns_ing",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))
                        .tr()),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("login_unlink_sns",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                              .tr()
                        ]),
                  ),
                  onPressed: () async {
                    final result = await c.unlinkProvider("apple.com");
                    if (result) {
                      c.linkedSNS.remove("apple.com");
                    }
                  },
                )
              ] else
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("login_link_sns_start",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                              .tr()
                        ]),
                  ),
                  onPressed: () async {
                    final result = await c.linkWithApple();
                    if (result) {
                      c.linkedSNS.add("apple.com");
                    }
                  },
                )
            ])),
      ],
    );
  }

  Widget _buildETCInfo(CampUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text("etc",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black54))
                .tr()),
        Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Text("-",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Spacer(),
              // 로그아웃
              OutlinedButton(
                style: OutlinedButton.styleFrom(primary: Colors.black),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("logout",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15))
                            .tr()
                      ]),
                ),
                onPressed: () async {
                  showTwoBtnAlert("login_logout".tr(), "logout".tr(), () {
                    Get.back();
                    user.logout();
                  });
                },
              )
            ])),
        SizedBox(height: 20),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Text("-",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Spacer(),
              // 탈퇴
              OutlinedButton(
                style: OutlinedButton.styleFrom(primary: Colors.black),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("login_unregistration",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15))
                            .tr()
                      ]),
                ),
                onPressed: () async {
                  showTwoBtnAlert("login_unregistration_msg".tr(),
                      "login_unregistration".tr(), () async {
                    final isSuccess = await user.signout();
                    if (isSuccess) {
                      showOneBtnAlert(
                          "login_unregistration_complete".tr(), "confirm".tr(),
                          () {
                        Get.back();
                      });
                    }
                  });
                },
              )
            ]))
      ],
    );
  }
}
