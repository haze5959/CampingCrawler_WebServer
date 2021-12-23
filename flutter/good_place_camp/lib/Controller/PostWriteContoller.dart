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
      showOneBtnAlert("posts_no_contents".tr, "confirm".tr, () {});
      return;
    }

    isLoading.value = true;

    final token = await Constants.user.value.getToken() ?? "";

    final newPosts = Post(type: postType.value + 1, title: title, body: body);
    final res = await ApiRepo.posts.createPosts(newPosts, token);
    if (res.result) {
      showOneBtnAlert("posts_success".tr, "confirm".tr, () {
        Get.back(result: true);
      });
    } else {
      showServerErrorAlert(res.msg, false);
    }

    isLoading.value = false;
  }
}
