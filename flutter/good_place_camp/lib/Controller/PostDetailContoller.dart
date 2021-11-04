import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  RxBool isLoading = true.obs;

  void reload() async {
    isLoading.value = true;
    // 아이디로 게시물과 댓글 검색
    Board board;

    if (isSecret) {
      final token = await Constants.user.value.firebaseUser?.getIdToken() ?? "";
      final res = await ApiRepo.posts.getSecretPosts(id, token);
      final data = res.data;
      if (!res.result) {
        if (res.msg == "Auth Fail") {
          showOneBtnAlert(
              "비밀글은 작성자만 확인할 수 있습니다.", "확인", () => Navigator.pop(Get.context!));
        } else {
          showOneBtnAlert(res.msg, "확인", () => Navigator.pop(Get.context!));
        }
        return;
      } else if (data == null) {
        print("reloadInfo result fail - " + res.msg);
        showOneBtnAlert("서버가 불안정 합니다. 잠시 후 다시 시도해주세요.", "확인", () {});
        return;
      }

      board = data;
    } else {
      final res = await ApiRepo.posts.getPosts(id);
      final data = res.data;
      if (!res.result) {
        showOneBtnAlert(res.msg, "확인", () => Navigator.pop(Get.context!));
        return;
      } else if (data == null) {
        print("reloadInfo result fail - " + res.msg);
        showOneBtnAlert("서버가 불안정 합니다. 잠시 후 다시 시도해주세요.", "확인", () {});
        return;
      }

      board = data;
    }

    posts = board.post;
    commentList = board.commentList;

    isLoading.value = false;
  }

  Future<bool> deletePosts() async {
    final token = Constants.user.value.isLogin
        ? await Constants.user.value.firebaseUser?.getIdToken() ?? ""
        : "";
    final res = await ApiRepo.posts.deletePosts(id, token);

    if (!res.result) {
      showOneBtnAlert(res.msg, "확인", () {});
      return false;
    }

    return true;
  }
}
