import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Repository
import 'package:good_place_camp/Repository/PostsRepository.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostDetailContoller extends GetxController {
  final int id;
  final String pw;

  PostDetailContoller({this.id, this.pw}) {
    reload();
  }

  PostsRepository repo = PostsRepository();

  Post posts;
  List<Comment> commentList = [];

  RxBool isLoading = true.obs;

  void reload() async {
    isLoading.value = true;
    // 아이디로 게시물과 댓글 검색
    Board board;

    if (pw != null) {
      final bytes = utf8.encode(pw);
      final key = sha1.convert(bytes).toString();
      final postsResult = await repo.getSecretPostsWith(id, key);

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

      if (board.post == null) {
        showOneBtnAlert(Get.context, "비밀번호가 일치하지 않습니다.", "확인",
            () => Navigator.pop(Get.context));
        return;
      }
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
}
