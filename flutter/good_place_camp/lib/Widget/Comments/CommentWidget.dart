import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Utils/DateUtils.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class CommentWidget extends StatelessWidget {
  final int postId;
  final bool canWrite;
  final RxList<Comment> commentList;

  CommentWidget(
      {required this.postId, required this.commentList, this.canWrite = true});

  @override
  Widget build(BuildContext context) {
    return _buildCommentList();
  }

  Widget _buildCommentList() {
    return Container(
        child: Obx(() => Column(children: [
              if (canWrite) _buildWriteCommentItem(),
              for (final comment in commentList) _buildCommentItem(comment)
            ])));
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  color: Colors.blueGrey[50],
                  child: Row(children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(comment.nick,
                            style:const TextStyle(fontWeight: FontWeight.bold))),
                    Text(getRemainTime(comment.updatedTime ?? DateTime.now()),
                        style: TextStyle(fontSize: 12)),
                    const Spacer(),
                    if (comment.nick == Constants.user.value.info.nick)
                      IconButton(
                        tooltip: "dialog_delete".tr(),
                        color: Colors.grey,
                        icon: const Icon(Icons.delete),
                        iconSize: 20,
                        onPressed: () {
                          showTwoBtnAlert("dialog_delete_confirm".tr(args: ["comment".tr()]), "delete".tr(),
                              () async {
                            final user = Constants.user.value.firebaseUser;
                            if (user != null) {
                              final token = await user.getIdToken();
                              final res = await ApiRepo.posts
                                  .deleteComment(comment.id!, token, postId);
                              if (!res.result) {
                                showServerErrorAlert(res.msg, false);
                                return;
                              }

                              showOneBtnAlert("dialog_delete_complete".tr(), "confirm".tr(), () {
                                commentList.remove(comment);
                              });
                            } else {
                              showRequiredLoginAlert();
                            }
                          });
                        },
                      )
                    else
                      IconButton(
                        tooltip: "dialog_report".tr(),
                        color: Colors.grey,
                        icon: const Icon(Icons.report_gmailerrorred_outlined),
                        iconSize: 20,
                        onPressed: () {
                          showReportAlert("comment_${comment.id}", "comment".tr());
                        },
                      )
                  ])),
              Container(color: Colors.black12, height: 1),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(comment.comment))
            ])));
  }

  Widget _buildWriteCommentItem() {
    TextEditingController nickControler = new TextEditingController();
    TextEditingController bodyControler = new TextEditingController();

    nickControler.text = Constants.user.value.isLogin
        ? Constants.user.value.info.nick!
        : "default_nick".tr();

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Column(children: [
              Container(
                  color: Colors.blueGrey[50],
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    SizedBox(
                        width: 150,
                        child: TextField(
                          readOnly: true,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                          controller: nickControler,
                          onTap: () {
                            if (!Constants.user.value.isLogin) {
                              showRequiredLoginAlert();
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "nick".tr(), labelText: 'nick'.tr()),
                        )),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        final body = bodyControler.text;

                        if (body.length == 0) {
                          showOneBtnAlert("no_contents".tr(), "confirm".tr(), () {});
                          return;
                        }

                        final user = Constants.user.value.firebaseUser;
                        if (user != null) {
                          final token = Constants.user.value.isLogin
                              ? await user.getIdToken()
                              : "";
                          final comment = Comment(
                              postId: postId,
                              nick: nickControler.text,
                              comment: body);
                          final res =
                              await ApiRepo.posts.createComment(comment, token);
                          if (!res.result) {
                            showServerErrorAlert(res.msg, false);
                            return;
                          }

                          commentList.insert(0, comment);
                        }
                      },
                      child: Text("dialog_registration").tr(),
                    )
                  ])),
              Container(color: Colors.black12, height: 1),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: bodyControler,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration:
                        InputDecoration(hintText: 'comment'.tr() + "...", labelText: 'comment'.tr()),
                  ))
            ])));
  }
}
