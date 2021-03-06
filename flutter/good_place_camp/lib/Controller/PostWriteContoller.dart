import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Repository
import 'package:good_place_camp/Repository/PostsRepository.dart';

class PostWriteContoller extends GetxController {
  final PostsRepository repo = PostsRepository();

  TextEditingController titleControler = new TextEditingController();
  TextEditingController bodyControler = new TextEditingController();

  RxInt postType = 0.obs;

  RxBool isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();

    reload();
  }

  void reload() async {
  }

  void makePosts() async {
    final title = titleControler.text;
    final body = bodyControler.text;

    if (title.length == 0 || body.length == 0) {
      showOneBtnAlert(Get.context, "제목과 내용을 입력해주세요.", "확인", () {});
      return;
    }

    isLoading.value = true;

    final token = Constants.user.value.isLogin
        ? await Constants.user.value.firebaseUser.getIdToken()
        : null;

    final result = await repo.postPostsWith(
        postType.value + 1, title, body, token);

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
