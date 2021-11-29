import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostDetailContoller extends GetxController {
  final int id;
  final bool isSecret;

  PostDetailContoller({required this.id, this.isSecret = false}) {
    reload();
  }

  Post? posts;
  List<Comment> commentList = [];

  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  void reload() async {
    // 아이디로 게시물과 댓글 검색
    Board board;

    if (isSecret) {
      final token = await Constants.user.value.firebaseUser?.getIdToken() ?? "";
      final res = await ApiRepo.posts.getSecretPosts(id, token);
      final data = res.data;
      if (!res.result) {
        if (res.msg == "Auth Fail") {
          showOneBtnAlert("posts_secret_unvisible".tr(), "confirm".tr(),
              () => Navigator.pop(Get.context!));
        } else {
          showOneBtnAlert(
              res.msg, "confirm".tr(), () => Navigator.pop(Get.context!));
        }
        return;
      } else if (data == null) {
        print("reloadInfo result fail - " + res.msg);
        showOneBtnAlert(
            "server_error".tr(args: [res.msg]), "confirm".tr(), () {});
        return;
      }

      board = data;
    } else {
      final res = await ApiRepo.posts.getPosts(id);
      final data = res.data;
      if (!res.result) {
        showOneBtnAlert(
            res.msg, "confirm".tr(), () => Navigator.pop(Get.context!));
        return;
      } else if (data == null) {
        print("reloadInfo result fail - " + res.msg);
        showOneBtnAlert(
            "server_error".tr(args: [res.msg]), "confirm".tr(), () {});
        return;
      }

      board = data;
    }

    posts = board.post;
    commentList = board.commentList;

    isLoading = false;
    update();
  }

  Future<bool> deletePosts() async {
    final token = Constants.user.value.isLogin
        ? await Constants.user.value.firebaseUser?.getIdToken() ?? ""
        : "";
    final res = await ApiRepo.posts.deletePosts(id, token);

    if (!res.result) {
      showOneBtnAlert(res.msg, "confirm".tr(), () {});
      return false;
    }

    return true;
  }
}
