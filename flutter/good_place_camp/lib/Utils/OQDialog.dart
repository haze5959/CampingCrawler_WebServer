import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Controller/HomeContoller.dart';
import 'package:good_place_camp/Model/CampUser.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/LoginPage.dart';

// Model
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showOneBtnAlert(String msg, String btnText, Function() confirmAction,
    {String? title}) {
  showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null
              ? Text(
                  title,
                  textAlign: TextAlign.center,
                )
              : null,
          content: Text(
            msg,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8.0),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreen,
                  textStyle: TextStyle(fontSize: 18),
                  minimumSize: Size(120, 45)),
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

void showTwoBtnAlert(String msg, String btnText, Function() confirmAction,
    {String? title}) {
  showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null
              ? Text(
                  title,
                  textAlign: TextAlign.center,
                )
              : null,
          content: Text(
            msg,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8.0),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  primary: Colors.lightGreen,
                  textStyle: TextStyle(fontSize: 18),
                  minimumSize: Size(120, 45)),
              child: Text("cancel".tr),
              onPressed: () {
                Get.back();
              },
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreen,
                  textStyle: TextStyle(fontSize: 18),
                  minimumSize: Size(120, 45)),
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

void showServerErrorAlert(String msg, bool isBack) {
  print("[SERVER ERR]: $msg");
  var errMsg = "";
  switch (msg) {
    case "server_error":
    case "param_fail":
      errMsg = "server_error".tr;
      break;
    case "auth_fail":
      errMsg = "auth_error".tr;
      showOneBtnAlert(errMsg, "confirm".tr, () {
        Get.toNamed("/login");
      });
      return;
    case "not_exist":
      errMsg = "not_exist_error".tr;
      break;
    case "already_exist":
      errMsg = "already_exist_error".tr;
      break;
    case "not_excute":
      errMsg = "not_excute_error".tr;
      break;
    case "sign_up_fail":
      errMsg = "sign_up_error".tr;
      break;
    default:
      print("Unknown error!!!");
      errMsg = "server_error".tr;
      break;
  }

  showOneBtnAlert(errMsg, "confirm".tr, () {
    if (isBack) {
      Get.back();
    }
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
                      hintText: "dialog_pw_rules".tr,
                      labelText: 'password'.tr,
                      errorText:
                          hasErr.value ? "dialog_pw_rules_msg".tr : null),
                ))
          ]),
          actions: [
            TextButton(
              child: Text("cancel".tr),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text("confirm".tr),
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
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Obx(() => TextField(
                  controller: bodyControler,
                  maxLines: 4,
                  decoration: InputDecoration(
                      hintText:
                          "dialog_report_hint".trParams({"id": type}) +
                              "...",
                      labelText:
                          "dialog_report_hint".trParams({"id": type}),
                      errorText: hasErr.value ? "no_contents".tr : null),
                ))
          ]),
          actions: [
            TextButton(
              child: Text("cancel".tr),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text("confirm".tr),
              onPressed: () async {
                if (_validateText()) {
                  final res =
                      await ApiRepo.posts.createReport(id, bodyControler.text);
                  if (!res.result) {
                    showServerErrorAlert(res.msg, false);
                    return;
                  }

                  Get.back();

                  showOneBtnAlert(
                      "dialog_report_confirm".tr, "cancel".tr, () {});
                }
              },
            )
          ],
        );
      });
}

void showCampEditRequestAlert(String id) {
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
          title: Text("수정이 필요한 부분에 대해서 요청해주세요!"),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ex) 예약 오픈일이 틀려요. XX월 XX일에 오픈합니다.",
                    style: TextStyle(color: Colors.grey)),
                Text("Ex) 예약가능 날짜가 있는데 달력에서는 없다고 나와요.",
                    style: TextStyle(color: Colors.grey)),
                Text("Ex) 캠핑장 사이트가 열리지 않아요 등등...",
                    style: TextStyle(color: Colors.grey)),
                Obx(() => TextField(
                      controller: bodyControler,
                      maxLines: 4,
                      decoration: InputDecoration(
                          hintText:
                              "dialog_edit_request_hint".trParams({"id": id}) +
                                  "...",
                          labelText:
                              "dialog_edit_request_hint".trParams({"id": id}),
                          errorText: hasErr.value ? "no_contents".tr : null),
                    ))
              ]),
          actions: [
            TextButton(
              child: Text("cancel".tr),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text("confirm".tr),
              onPressed: () async {
                if (_validateText()) {
                  final res =
                      await ApiRepo.posts.createReport(id, bodyControler.text);
                  if (!res.result) {
                    showServerErrorAlert(res.msg, false);
                    return;
                  }

                  Get.back();

                  showOneBtnAlert(
                      "dialog_edit_request_confirm".tr, "cancel".tr, () {});
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
          title: Text(
            "required_login_title".tr,
            textAlign: TextAlign.center,
          ),
          content: Text(
            "required_login_msg".tr,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8.0),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  primary: Colors.lightGreen,
                  textStyle: TextStyle(fontSize: 18),
                  minimumSize: Size(120, 45)),
              child: Text("cancel".tr),
              onPressed: () {
                Get.back();
              },
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreen,
                  textStyle: TextStyle(fontSize: 18),
                  minimumSize: Size(120, 45)),
              child: Text("login_start".tr),
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
                    child: Text("dialog_grade".tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black54))),
                SizedBox(
                    width: cellWidth,
                    child: Text("dialog_condition".tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black54)))
              ]),
              const Divider(thickness: 1),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                    width: cellWidth,
                    child: Text(CampRating.level01.getLevelText())),
                SizedBox(width: cellWidth, child: Text("dialog_condition_1".tr))
              ]),
              const SizedBox(height: 10),
              Row(children: [
                SizedBox(
                    width: cellWidth,
                    child: Text(CampRating.level02.getLevelText())),
                SizedBox(width: cellWidth, child: Text("dialog_condition_2".tr))
              ]),
              SizedBox(height: 10),
              Row(children: [
                SizedBox(
                    width: cellWidth,
                    child: Text(CampRating.level03.getLevelText())),
                SizedBox(width: cellWidth, child: Text("dialog_condition_3".tr))
              ]),
            ],
          ),
          actions: [
            TextButton(
              child: Text("confirm".tr),
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

  RxString errText = "no_contents".tr.obs;

  bool _validateText() {
    if (bodyControler.text.length == 0) {
      errText.value = "no_contents".tr;
      hasErr.value = true;
      return false;
    } else if (bodyControler.text.length > 10) {
      errText.value = "login_condition_1".tr;
      hasErr.value = true;
      return false;
    } else if (bodyControler.text
        .contains(new RegExp(r'[!@#$%^&*(),.?":{}|<> ]'))) {
      errText.value = "login_condition_2".tr;
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
                      hintText: "nick".tr + "...",
                      labelText: 'nick'.tr,
                      errorText: hasErr.value ? errText.value : null),
                ))
          ]),
          actions: [
            TextButton(
              child: Text("cancel".tr),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text("dialog_setting".tr),
              onPressed: () async {
                final token = await Constants.user.value.getToken();
                if (_validateText() && token != null) {
                  final res =
                      await ApiRepo.user.putUserNick(token, bodyControler.text);
                  if (!res.result) {
                    showServerErrorAlert(res.msg, false);
                    return;
                  }

                  Get.back();
                  Constants.user.value.info.nick = bodyControler.text;

                  showOneBtnAlert("dialog_change_complete".tr, "close".tr, () {
                    Constants.user.refresh();
                  });
                }
              },
            )
          ],
        );
      });
}

void showAreaFilterDialog() {
  final selectedArea = <CampArea>{}.obs;
  selectedArea.addAll(Constants.myArea);
  showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Obx(() => Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  "dialog_select_area_msg".tr,
                ),
                SizedBox(height: 20),
                for (final area in CampArea.values)
                  CheckboxListTile(
                    title: Text(area.toAreaString()),
                    value: selectedArea.contains(area),
                    onChanged: (bool? value) {
                      if (value == null) {
                        return;
                      }

                      if (value) {
                        selectedArea.add(area);
                      } else {
                        selectedArea.remove(area);
                      }
                    },
                  ),
              ])),
          actions: [
            TextButton(
              child: Text("cancel".tr),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text("confirm".tr),
              onPressed: () async {
                if (selectedArea.length == 0) {
                  showOneBtnAlert("dialog_select_area_empty_err_msg".tr,
                      "confirm".tr, () {});
                  return;
                }

                Constants.myArea.assignAll(selectedArea);
                final HomeController c = Get.find();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final bit = toAreaBit(Constants.myArea);
                prefs.setInt(MY_AREA_BIT_KEY, bit);

                c.reload();
                Get.back();
              },
            )
          ],
        );
      });
}
