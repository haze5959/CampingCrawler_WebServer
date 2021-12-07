import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:good_place_camp/Model/CampUser.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/LoginPage.dart';

void showOneBtnAlert(String msg, String btnText, Function() confirmAction) {
  showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            msg,
          ),
          actions: [
            TextButton(
              child: Text(btnText),
              onPressed: () {
                Get.back();
                confirmAction();
              },
            )
          ],
        );
      });
}

void showTwoBtnAlert(String msg, String btnText, Function() confirmAction) {
  showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            msg,
          ),
          actions: [
            TextButton(
              child: const Text("cancel").tr(),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(btnText),
              onPressed: () {
                Get.back();
                confirmAction();
              },
            )
          ],
        );
      });
}

void showPwAlert(String msg, Function(String pw) confirmAction) {
  TextEditingController pwControler = new TextEditingController();

  RxBool hasErr = false.obs;

  bool _validatePassword() {
    if (pwControler.text.length != 6) {
      hasErr.value = true;
      return false;
    }

    return true;
  }

  showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              msg,
            ),
            Obx(() => TextField(
                  controller: pwControler,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      hintText: "dialog_pw_rules".tr(),
                      labelText: 'password'.tr(),
                      errorText: hasErr.value ? "dialog_pw_rules_msg".tr() : null),
                ))
          ]),
          actions: [
            TextButton(
              child: const Text("cancel").tr(),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: const Text("confirm").tr(),
              onPressed: () {
                if (_validatePassword()) {
                  Get.back();
                  confirmAction(pwControler.text);
                }
              },
            )
          ],
        );
      });
}

void showReportAlert(String id, String type) {
  TextEditingController bodyControler = new TextEditingController();
  RxBool hasErr = false.obs;

  bool _validateText() {
    if (bodyControler.text.length == 0) {
      hasErr.value = true;
      return false;
    }

    return true;
  }

  showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "dialog_report_id".tr(args: [id]),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Obx(() => TextField(
                  controller: bodyControler,
                  decoration: InputDecoration(
                      hintText: "dialog_report_hint".tr(args: [type]) + "...",
                      labelText: "dialog_report_hint".tr(args: [type]),
                      errorText: hasErr.value ? "no_contents".tr() : null),
                ))
          ]),
          actions: [
            TextButton(
              child: const Text("cancel").tr(),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: const Text("confirm").tr(),
              onPressed: () async {
                if (_validateText()) {
                  final res =
                      await ApiRepo.posts.createReport(id, bodyControler.text);
                  if (!res.result) {
                    showOneBtnAlert(res.msg, "confirm".tr(), () {});
                    return;
                  }

                  Get.back();

                  showOneBtnAlert("dialog_report_confirm".tr(), "cancel".tr(), () {});
                }
              },
            )
          ],
        );
      });
}

void showRequiredLoginAlert() {
  showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            "required_login",
          ).tr(),
          actions: [
            TextButton(
              child: const Text("cancel").tr(),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: const Text("login_start").tr(),
              onPressed: () {
                Get.off(LoginPage());
              },
            )
          ],
        );
      });
}

void showRatingInfoAlert() {
  const double cellWidth = 250;
  showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                    width: cellWidth,
                    child: const Text("dialog_grade",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black54)).tr()),
                SizedBox(
                    width: cellWidth,
                    child: const Text("dialog_condition",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black54)).tr())
              ]),
              const Divider(thickness: 1),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                    width: cellWidth,
                    child: Text(CampRating.level01.getLevelText())),
                SizedBox(width: cellWidth, child: const Text("dialog_condition_1").tr())
              ]),
              const SizedBox(height: 10),
              Row(children: [
                SizedBox(
                    width: cellWidth,
                    child: Text(CampRating.level02.getLevelText())),
                SizedBox(width: cellWidth, child: const Text("dialog_condition_2").tr())
              ]),
              SizedBox(height: 10),
              Row(children: [
                SizedBox(
                    width: cellWidth,
                    child: Text(CampRating.level03.getLevelText())),
                SizedBox(width: cellWidth, child: const Text("dialog_condition_3").tr())
              ]),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("confirm").tr(),
              onPressed: () {
                Get.back();
              },
            )
          ],
        );
      });
}

void showChangeNickAlert() {
  TextEditingController bodyControler = new TextEditingController();

  RxBool hasErr = false.obs;

  RxString errText = "no_contents".tr().obs;

  bool _validateText() {
    if (bodyControler.text.length == 0) {
      errText.value = "no_contents".tr();
      hasErr.value = true;
      return false;
    } else if (bodyControler.text.length > 10) {
      errText.value = "login_condition_1".tr();
      hasErr.value = true;
      return false;
    } else if (bodyControler.text
        .contains(new RegExp(r'[!@#$%^&*(),.?":{}|<> ]'))) {
      errText.value = "login_condition_2".tr();
      hasErr.value = true;
      return false;
    }

    return true;
  }

  bodyControler.text = Constants.user.value.info.nick ?? "";

  showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Obx(() => TextField(
                  controller: bodyControler,
                  decoration: InputDecoration(
                      hintText: "nick".tr() + "...",
                      labelText: 'nick'.tr(),
                      errorText: hasErr.value ? errText.value : null),
                ))
          ]),
          actions: [
            TextButton(
              child: const Text("cancel").tr(),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: const Text("dialog_setting").tr(),
              onPressed: () async {
                User? user = Constants.user.value.firebaseUser;
                if (_validateText() && user != null) {
                  final idToken = await user.getIdToken();
                  final res = await ApiRepo.user
                      .putUserNick(idToken, bodyControler.text);
                  if (!res.result) {
                    showOneBtnAlert(res.msg, "confirm".tr(), () {});
                    return;
                  }

                  Get.back();
                  Constants.user.value.info.nick = bodyControler.text;

                  showOneBtnAlert("dialog_change_complete".tr(), "close".tr(), () {
                    Constants.user.refresh();
                  });
                }
              },
            )
          ],
        );
      });
}
