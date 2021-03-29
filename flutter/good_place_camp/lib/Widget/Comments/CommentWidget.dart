import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class CommentWidget extends StatelessWidget {
  final bool canWrite;
  final List<Comment> commentList;

  CommentWidget({this.commentList, this.canWrite = true});

  @override
  Widget build(BuildContext context) {
    return _buildCommentList(context);
  }

  Widget _buildCommentList(BuildContext context) {
    return Container(
      child: Column(children: [
        if (canWrite) _buildWriteCommentItem(),
        for (final comment in commentList) _buildCommentItem(comment)
      ]),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Column(children: [
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
                        // 신고하기
                      },
                    )
                  ])),
              Container(color: Colors.black12, height: 1),
              Padding(padding: EdgeInsets.all(20), child: Text(comment.comment))
            ])));
  }

  Widget _buildWriteCommentItem() {
    TextEditingController nickControler = new TextEditingController();
    TextEditingController bodyControler = new TextEditingController();

    return Container(
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
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      controller: nickControler,
                      decoration:
                          InputDecoration(hintText: "익명의 캠퍼", labelText: '닉네임'),
                    )),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // 등록하기
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
        ]));
  }

  String _getDateStr(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    final String formatted = formatter.format(date);
    return formatted;
  }
}
