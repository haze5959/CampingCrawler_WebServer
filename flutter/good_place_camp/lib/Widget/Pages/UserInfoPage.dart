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
import 'package:good_place_camp/Widget/ObxLoadingWidget.dart';

class UserInfoPage extends StatelessWidget {
  final UserInfoController c = UserInfoController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserInfoController>(
      init: c,
      builder: (_) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("mypage").tr(),
            actions: [],
          ),
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
            child: const Text("user_info",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black54))
                .tr()),
        const Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              // 닉네임 설정
              const Text("nick",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                  .tr(),
              const Spacer(),
              OutlinedButton(
                style: OutlinedButton.styleFrom(primary: Colors.black),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(user.info.nick ?? "",
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
              const Text("dialog_grade",
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
              const Spacer(),
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
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: const Text("subscribe_info",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black54))
                .tr()),
        const Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              // 구독하러가기 or 푸시설정 바로가기
              if (user.info.usePushSubscription ?? false) ...[
                const Text("subscribe_ing",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))
                    .tr(),
                const Spacer(),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("notification_setting",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                              .tr()
                        ]),
                  ),
                  onPressed: () async {
                    Get.toNamed("/promotion");
                  },
                )
              ] else ...[
                const Text("subscribe_no_info",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))
                    .tr(),
                const Spacer(),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("subscribe_noti",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))
                              .tr()
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
                child: const Text("login_link_sns",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black54))
                    .tr()),
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
                  const Text("login_google_btn",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15))
                      .tr(),
                  const Spacer(),
                  if (c.linkedSNS.contains("google.com")) ...[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text("login_link_sns_ing",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15))
                            .tr()),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(primary: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("login_unlink_sns",
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("login_link_sns_start",
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
                  const Text("login_facebook_btn",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15))
                      .tr(),
                  const Spacer(),
                  if (c.linkedSNS.contains("facebook.com")) ...[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text("login_link_sns_ing",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15))
                            .tr()),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(primary: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("login_unlink_sns",
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("login_link_sns_start",
                                      style: const TextStyle(
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
                  const Text("login_twitter_btn",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15))
                      .tr(),
                  const Spacer(),
                  if (c.linkedSNS.contains("twitter.com")) ...[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text("login_link_sns_ing",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15))
                            .tr()),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(primary: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("login_unlink_sns",
                                      style: const TextStyle(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("login_link_sns_start",
                                      style: const TextStyle(
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
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: ImageIcon(const AssetImage("assets/ico_apple.png"),
                          size: 15, color: Colors.black)),
                  const Text("login_apple_btn",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15))
                      .tr(),
                  const Spacer(),
                  if (c.linkedSNS.contains("apple.com")) ...[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text("login_link_sns_ing",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15))
                            .tr()),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(primary: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("login_unlink_sns",
                                      style: const TextStyle(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("login_link_sns_start",
                                      style: const TextStyle(
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
        ));
  }

  Widget _buildETCInfo(CampUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: const Text("etc",
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black54))
                .tr()),
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
                        const Text("logout",
                                style: const TextStyle(
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
                        const Text("login_unregistration",
                                style: const TextStyle(
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
