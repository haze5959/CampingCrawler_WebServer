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
                Navigator.of(context).pop();
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
              child: Text("cancel").tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(btnText),
              onPressed: () {
                Navigator.of(context).pop();
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
              child: Text("cancel").tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("confirm").tr(),
              onPressed: () {
                if (_validatePassword()) {
                  Navigator.of(context).pop();
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
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Obx(() => TextField(
                  controller: bodyControler,
                  decoration: InputDecoration(
                      hintText: "해당 $type의 신고 내용...",
                      labelText: '해당 $type의 신고 내용',
                      errorText: hasErr.value ? "내용을 입력해주세요." : null),
                ))
          ]),
          actions: [
            TextButton(
              child: Text("cancel").tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("confirm").tr(),
              onPressed: () async {
                if (_validateText()) {
                  final res =
                      await ApiRepo.posts.createReport(id, bodyControler.text);
                  if (!res.result) {
                    showOneBtnAlert(res.msg, "confirm".tr(), () {});
                    return;
                  }

                  Navigator.of(context).pop();

                  showOneBtnAlert("신고되었습니다.", "닫기", () {});
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
          content: Text(
            "로그인이 필요한 서비스입니다.",
          ),
          actions: [
            TextButton(
              child: Text("cancel").tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("로그인하기"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push<void>(
                  context,
                  CupertinoPageRoute(builder: (context) => LoginPage()),
                );
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
                    child: Text("등급",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black54))),
                SizedBox(
                    width: cellWidth,
                    child: Text("조건",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black54)))
              ]),
              Divider(thickness: 1),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                    width: cellWidth,
                    child: Text(CampRating.level01.getLevelText())),
                SizedBox(width: cellWidth, child: Text("초기 등급"))
              ]),
              SizedBox(height: 10),
              Row(children: [
                SizedBox(
                    width: cellWidth,
                    child: Text(CampRating.level02.getLevelText())),
                SizedBox(width: cellWidth, child: Text("명당캠핑 알림 서비스 구독 시"))
              ]),
              SizedBox(height: 10),
              Row(children: [
                SizedBox(
                    width: cellWidth,
                    child: Text(CampRating.level03.getLevelText())),
                SizedBox(width: cellWidth, child: Text("관리자의 승인 필요"))
              ]),
            ],
          ),
          actions: [
            TextButton(
              child: Text("confirm").tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

void showChangeNickAlert() {
  TextEditingController bodyControler = new TextEditingController();

  RxBool hasErr = false.obs;

  RxString errText = "내용을 입력해주세요.".obs;

  bool _validateText() {
    if (bodyControler.text.length == 0) {
      errText.value = "내용을 입력해주세요.";
      hasErr.value = true;
      return false;
    } else if (bodyControler.text.length > 10) {
      errText.value = "10글자 이하로 줄여주세요.";
      hasErr.value = true;
      return false;
    } else if (bodyControler.text
        .contains(new RegExp(r'[!@#$%^&*(),.?":{}|<> ]'))) {
      errText.value = "특수문자 및 공백을 제외해주세요.";
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
                      hintText: "닉네임...",
                      labelText: '닉네임',
                      errorText: hasErr.value ? errText.value : null),
                ))
          ]),
          actions: [
            TextButton(
              child: Text("cancel").tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("설정하기"),
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

                  Navigator.of(context).pop();
                  Constants.user.value.info.nick = bodyControler.text;

                  showOneBtnAlert("변경되었습니다.", "close".tr(), () {
                    Constants.user.refresh();
                  });
                }
              },
            )
          ],
        );
      });
}
