import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Repository
import 'package:good_place_camp/Repository/PostsRepository.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class CommentWidget extends StatelessWidget {
  final int postId;
  final bool canWrite;
  RxList<Comment> commentList;

  CommentWidget({this.postId, this.commentList, this.canWrite = true});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                  color: Colors.blueGrey[50],
                  child: Row(children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(comment.nick,
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Text(_getDateStr(comment.editTime),
                        style: TextStyle(fontSize: 12)),
                    Spacer(),
                    IconButton(
                      tooltip: "신고하기",
                      icon: Icon(Icons.not_interested),
                      iconSize: 20,
                      onPressed: () {
                        showReportAlert(Get.context, "comment_${comment.id}");
                      },
                    )
                  ])),
              Container(color: Colors.black12, height: 1),
              Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 10), child: Text(comment.comment))
            ])));
  }

  Widget _buildWriteCommentItem() {
    TextEditingController nickControler = new TextEditingController();
    TextEditingController bodyControler = new TextEditingController();

    nickControler.text = "익명의 캠퍼";

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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      controller: nickControler,
                      decoration:
                          InputDecoration(hintText: "닉네임", labelText: '닉네임'),
                    )),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final body = bodyControler.text;

                    if (body.length == 0) {
                      showOneBtnAlert(
                          Get.context, "내용을 입력해주세요.", "확인", () {});
                      return;
                    }

                    final repo = PostsRepository();
                    final result = await repo.postCommentWith(
                        postId, nickControler.text, body);

                    if (result.hasError) {
                      showOneBtnAlert(
                          Get.context, result.statusText, "확인", () {});
                      return;
                    } else if (!result.body.result) {
                      showOneBtnAlert(
                          Get.context, result.body.msg, "확인", () {});
                      return;
                    }

                    commentList.insert(
                        0,
                        Comment(0, postId, DateTime.now(), nickControler.text,
                            bodyControler.text));
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
                decoration: InputDecoration(hintText: "댓글...", labelText: '댓글'),
              ))
        ])));
  }

  String _getDateStr(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    final String formatted = formatter.format(date);
    return formatted;
  }
}
