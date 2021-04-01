import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

// Repository
import 'package:good_place_camp/Repository/PostsRepository.dart';

class PostWriteContoller extends GetxController {
  PostsRepository repo = PostsRepository();

  TextEditingController nickControler =
      new TextEditingController(text: "익명의 캠퍼");
  TextEditingController titleControler = new TextEditingController();
  TextEditingController bodyControler = new TextEditingController();
  TextEditingController pwControler = new TextEditingController();

  RxInt postType = 0.obs;

  RxBool isLoading = false.obs;

  // PostDetailContoller() {
  //   reload();
  // }

  void reload() async {}

  void makePosts() async {
    final title = titleControler.text;
    final body = bodyControler.text;
    final nick = nickControler.text;

    if (title.length == 0 || body.length == 0) {
      showOneBtnAlert(Get.context, "제목과 내용을 입력해주세요.", "확인", () {});
      return;
    }

    String pwEnc;
    if (postType.value == 2) {
      // 비밀글
      if (pwControler.text.length != 6) {
        showOneBtnAlert(Get.context, "6자리 숫자로된 비밀번호를 입력해주세요.", "확인", () {});
        return;
      }

      final bytes = utf8.encode(pwControler.text);
      pwEnc = sha1.convert(bytes).toString();
    }

    isLoading.value = true;

    final result =
        await repo.postPostsWith(postType.value + 1, title, body, nick, pwEnc);

    if (result.hasError) {
      showOneBtnAlert(Get.context, result.statusText, "확인", () {
        isLoading.value = false;
      });
      return;
    } else if (!result.body.result) {
      showOneBtnAlert(Get.context, result.body.msg, "확인", () {
        isLoading.value = false;
      });
      return;
    }

    isLoading.value = false;

    showOneBtnAlert(Get.context, "등록되었습니다.", "확인", () {
        Get.back(result: true);
      });
  }
}
