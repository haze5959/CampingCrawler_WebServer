import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Model/Post.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';

class PostWriteContoller extends GetxController {
  TextEditingController titleControler = new TextEditingController();
  TextEditingController bodyControler = new TextEditingController();

  RxInt postType = 0.obs;

  RxBool isLoading = false.obs;

  void makePosts() async {
    final title = titleControler.text;
    final body = bodyControler.text;

    if (title.length == 0 || body.length == 0) {
      showOneBtnAlert("제목과 내용을 입력해주세요.", "확인", () {});
      return;
    }

    isLoading.value = true;

    final token = Constants.user.value.isLogin
        ? await Constants.user.value.firebaseUser?.getIdToken() ?? ""
        : "";

    final newPosts = Post(type: postType.value + 1, title: title, body: body);
    final res = await ApiRepo.posts.createPosts(newPosts, token);
    if (res.result) {
      showOneBtnAlert("등록되었습니다.", "확인", () {
        Get.back(result: true);
      });
    } else {
      showOneBtnAlert(res.msg, "확인", () {});
    }

    isLoading.value = false;
  }
}
