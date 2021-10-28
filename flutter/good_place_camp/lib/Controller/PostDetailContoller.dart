import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Repository
import 'package:good_place_camp/Repository/PostsRepository.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostDetailContoller extends GetxController {
  final int id;
  final bool isSecret;

  PostDetailContoller({this.id, this.isSecret = false}) {
    reload();
  }

  final PostsRepository repo = PostsRepository();

  Post posts;
  List<Comment> commentList = [];

  RxBool isLoading = true.obs;

  void reload() async {
    isLoading.value = true;
    // 아이디로 게시물과 댓글 검색
    Board board;

    if (isSecret) {
      final token = await Constants.user.value.firebaseUser.getIdToken();
      final postsResult = await repo.getSecretPostsWith(id, token);

      if (postsResult.hasError) {
        showOneBtnAlert(Get.context, postsResult.statusText, "확인",
            () => Navigator.pop(Get.context));
        return;
      } else if (!postsResult.body.result) {
        if (postsResult.body.msg == "Auth Fail") {
          showOneBtnAlert(Get.context, "비밀글은 작성자만 확인할 수 있습니다.", "확인",
            () => Navigator.pop(Get.context));
        } else {
          showOneBtnAlert(Get.context, postsResult.body.msg, "확인",
            () => Navigator.pop(Get.context));
        }
        return;
      }

      board = Board.fromJson(postsResult.body.data);
    } else {
      final postsResult = await repo.getPostsWith(id);

      if (postsResult.hasError) {
        showOneBtnAlert(Get.context, postsResult.statusText, "확인",
            () => Navigator.pop(Get.context));
        return;
      } else if (!postsResult.body.result) {
        showOneBtnAlert(Get.context, postsResult.body.msg, "확인",
            () => Navigator.pop(Get.context));
        return;
      }

      board = Board.fromJson(postsResult.body.data);
    }

    posts = board.post;
    commentList = board.commentList;

    isLoading.value = false;
  }

  Future<bool> deletePosts() async {
    final token = Constants.user.value.isLogin
        ? await Constants.user.value.firebaseUser.getIdToken()
        : null;
    final result = await repo.deletePosts(token, id);

    if (result.hasError) {
      showOneBtnAlert(Get.context, result.statusText, "확인", () {});
      return false;
    } else if (!result.body.result) {
      showOneBtnAlert(Get.context, result.body.msg, "확인", () {});
      return false;
    }

    return true;
  }
}
