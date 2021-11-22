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
    return _buildCommentList(context);
  }

  Widget _buildCommentList(BuildContext context) {
    return Container(
        child: Obx(() => Column(children: [
              if (canWrite) _buildWriteCommentItem(),
              for (final comment in commentList) _buildCommentItem(comment)
            ])));
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  color: Colors.blueGrey[50],
                  child: Row(children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(comment.nick,
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Text(getRemainTime(comment.editTime ?? DateTime.now()),
                        style: TextStyle(fontSize: 12)),
                    Spacer(),
                    if (comment.nick == Constants.user.value.info.nick)
                      IconButton(
                        tooltip: "삭제하기",
                        color: Colors.grey,
                        icon: Icon(Icons.delete),
                        iconSize: 20,
                        onPressed: () {
                          showTwoBtnAlert("해당 댓글을 정말 삭제하시겠습니까?", "삭제",
                              () async {
                            final user = Constants.user.value.firebaseUser;
                            if (user != null) {
                              final token = await user.getIdToken();
                              final res = await ApiRepo.posts
                                  .deleteComment(comment.id!, token, postId);
                              if (!res.result) {
                                showOneBtnAlert(res.msg, "확인", () {});
                                return;
                              }

                              showOneBtnAlert("삭제되었습니다.", "확인", () {
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
                        tooltip: "신고하기",
                        color: Colors.grey,
                        icon: Icon(Icons.report_gmailerrorred_outlined),
                        iconSize: 20,
                        onPressed: () {
                          showReportAlert("comment_${comment.id}", "댓글");
                        },
                      )
                  ])),
              Container(color: Colors.black12, height: 1),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(comment.comment))
            ])));
  }

  Widget _buildWriteCommentItem() {
    TextEditingController nickControler = new TextEditingController();
    TextEditingController bodyControler = new TextEditingController();

    nickControler.text = Constants.user.value.isLogin
        ? Constants.user.value.info.nick!
        : "익명의 캠퍼";

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Column(children: [
              Container(
                  color: Colors.blueGrey[50],
                  padding: EdgeInsets.all(10),
                  child: Row(children: [
                    SizedBox(
                        width: 150,
                        child: TextField(
                          readOnly: true,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                          controller: nickControler,
                          onTap: () {
                            if (!Constants.user.value.isLogin) {
                              showRequiredLoginAlert();
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "닉네임", labelText: '닉네임'),
                        )),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        final body = bodyControler.text;

                        if (body.length == 0) {
                          showOneBtnAlert("내용을 입력해주세요.", "확인", () {});
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
                            showOneBtnAlert(res.msg, "확인", () {});
                            return;
                          }

                          commentList.insert(0, comment);
                        }
                      },
                      child: Text("등록하기"),
                    )
                  ])),
              Container(color: Colors.black12, height: 1),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: bodyControler,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration:
                        InputDecoration(hintText: "댓글...", labelText: '댓글'),
                  ))
            ])));
  }
}
