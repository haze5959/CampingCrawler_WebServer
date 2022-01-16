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
  final TextEditingController bodyControler = TextEditingController();

  final String nick = Constants.user.value.isLogin
      ? Constants.user.value.info!.nick
      : "default_nick".tr;

  PostDetailContoller({required this.id, this.isSecret = false}) {
    reload();
  }

  Post? posts;
  List<Comment> commentList = [];

  bool isLoading = true;
  RxBool isCommentLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  void reload() async {
    // 아이디로 게시물과 댓글 검색
    Board board;

    if (isSecret) {
      final token = await Constants.user.value.getToken() ?? "";
      final res = await ApiRepo.posts.getSecretPosts(id, token);
      if (!res.result) {
        showServerErrorAlert(res.msg, true);
        return;
      }

      final data = res.data!;
      board = data;
    } else {
      final res = await ApiRepo.posts.getPosts(id);
      if (!res.result) {
        showServerErrorAlert(res.msg, true);
        return;
      }

      final data = res.data!;
      board = data;
    }

    posts = board.posts;
    commentList = board.commentList;

    isLoading = false;
    update();
  }

  Future<bool> deletePosts() async {
    final token = await Constants.user.value.getToken() ?? "";
    final res = await ApiRepo.posts.deletePosts(id, token);

    if (!res.result) {
      showServerErrorAlert(res.msg, false);
      return false;
    }

    return true;
  }

  void commentAddHandler() async {
    final body = bodyControler.text;
    if (body.length == 0) {
      showOneBtnAlert("no_contents".tr, "confirm".tr, () {});
      return;
    }

    isCommentLoading.value = true;

    final token = await Constants.user.value.getToken();
    final res = await ApiRepo.posts.createComment(body, id, token);
    isCommentLoading.value = false;
    if (!res.result) {
      showServerErrorAlert(res.msg, false);
      return;
    }

    reload();
  }

  void commentRemoveHandler(Comment comment) {
    showTwoBtnAlert(
        "dialog_delete_confirm".trParams({"id": "comment".tr}), "delete".tr,
        () async {
      final token = await Constants.user.value.getToken();
      if (token != null) {
        final res = await ApiRepo.posts.deleteComment(comment.id!, token, id);
        if (!res.result) {
          showServerErrorAlert(res.msg, false);
          return;
        }

        showOneBtnAlert("dialog_delete_complete".tr, "confirm".tr, () {
          commentList.remove(comment);
          update();
        });
      } else {
        showRequiredLoginAlert();
      }
    });
  }
}
