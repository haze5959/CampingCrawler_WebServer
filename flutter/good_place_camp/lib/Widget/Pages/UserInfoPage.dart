import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Controller
import 'package:good_place_camp/Controller/UserInfoController.dart';

// Models
import 'package:good_place_camp/Model/CampUser.dart';
import 'package:good_place_camp/Widget/Common/CommonAppBar.dart';

// Widgets
import 'package:good_place_camp/Widget/Common/ObxLoadingWidget.dart';

class UserInfoPage extends StatelessWidget {
  final UserInfoController c = UserInfoController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserInfoController>(
        init: c,
        builder: (_) {
          return Scaffold(
              appBar: CommonAppBar(pageName: "mypage".tr),
              body: Stack(children: [
                if (Constants.user.value.isLogin)
                  SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Center(
                        child: Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: _buildInfoContent(Constants.user.value))),
                  ),
                obxLoadingWidget(c.isLoading)
              ]));
        });
  }

  Widget _buildInfoContent(CampUser user) {
    return Column(
      children: [
        const SizedBox(height: 50),
        _buildUserInfo(user),
        const SizedBox(height: 50),
        _buildSubscriptInfo(user),
        const SizedBox(height: 50),
        _buildSNSInfo(user),
        const SizedBox(height: 50),
        _buildETCInfo(user),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildUserInfo(CampUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text("user_info",
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black54))),
        const Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              // 닉네임 설정
              Text("nick".tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              OutlinedButton(
                style: OutlinedButton.styleFrom(primary: Colors.black),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(user.info?.nick ?? "",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                onPressed: () async {
                  showChangeNickAlert();
                },
              )
            ])),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              // 레벨
              Text("dialog_grade".tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              Tooltip(
                  message: "dialog_grade_auth".tr,
                  child: IconButton(
                    onPressed: () {
                      showRatingInfoAlert();
                    },
                    icon: const Icon(
                      Icons.info,
                    ),
                  )),
              const Spacer(),
              Text(user.info?.level.getLevelText() ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15))
            ]))
      ],
    );
  }

  Widget _buildSubscriptInfo(CampUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text("subscribe_info".tr,
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black54))),
        const Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              // 구독하러가기 or 푸시설정 바로가기
              if (user.info?.usePushSubscription ?? false) ...[
                Text("subscribe_ing".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const Spacer(),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("notification_setting".tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15))
                        ]),
                  ),
                  onPressed: () async {
                    Get.toNamed("/promotion");
                  },
                )
              ] else ...[
                Text("subscribe_no_info".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const Spacer(),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("subscribe_noti".tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))
                        ]),
                  ),
                  onPressed: () async {
                    Get.toNamed("/promotion");
                  },
                )
              ]
            ]))
      ],
    );
  }

  Widget _buildSNSInfo(CampUser user) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text("login_link_sns".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black54))),
            const Divider(
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: ImageIcon(
                          const AssetImage("assets/ico_google.png"),
                          size: 15,
                          color: Colors.deepOrange[700])),
                  Text("login_google_btn".tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const Spacer(),
                  if (c.linkedSNS.contains("google.com")) ...[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("login_link_sns_ing".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(primary: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("login_unlink_sns".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("login_link_sns_start".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
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
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: ImageIcon(
                          const AssetImage("assets/ico_facebook.png"),
                          size: 15,
                          color: Colors.blue[700])),
                  Text("login_facebook_btn".tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const Spacer(),
                  if (c.linkedSNS.contains("facebook.com")) ...[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("login_link_sns_ing".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(primary: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("login_unlink_sns".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("login_link_sns_start".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
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
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: ImageIcon(
                          const AssetImage("assets/ico_twitter.png"),
                          size: 15,
                          color: Colors.lightBlue[700])),
                  Text("login_twitter_btn".tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const Spacer(),
                  if (c.linkedSNS.contains("twitter.com")) ...[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("login_link_sns_ing".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(primary: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("login_unlink_sns".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("login_link_sns_start".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
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
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: ImageIcon(const AssetImage("assets/ico_apple.png"),
                          size: 15, color: Colors.black)),
                  Text("login_apple_btn".tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const Spacer(),
                  if (c.linkedSNS.contains("apple.com")) ...[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("login_link_sns_ing".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(primary: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("login_unlink_sns".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("login_link_sns_start".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
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
        ));
  }

  Widget _buildETCInfo(CampUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text("etc".tr,
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black54))),
        const Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              const Text("-",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              // 로그아웃
              OutlinedButton(
                style: OutlinedButton.styleFrom(primary: Colors.black),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("logout".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))
                      ]),
                ),
                onPressed: () async {
                  showTwoBtnAlert("login_logout".tr, "logout".tr, () {
                    Get.back();
                    user.logout();
                  });
                },
              )
            ])),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              const Text("-",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              // 탈퇴
              OutlinedButton(
                style: OutlinedButton.styleFrom(primary: Colors.black),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("login_unregistration".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))
                      ]),
                ),
                onPressed: () async {
                  showTwoBtnAlert(
                      "login_unregistration_msg".tr, "login_unregistration".tr,
                      () async {
                    final isSuccess = await user.signout();
                    if (isSuccess) {
                      showOneBtnAlert(
                          "login_unregistration_complete".tr, "confirm".tr, () {
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
