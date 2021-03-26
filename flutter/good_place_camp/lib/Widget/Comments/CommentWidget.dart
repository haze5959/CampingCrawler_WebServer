import 'dart:html';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

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
          for (final comment in commentList)
            _buildCommentItem(comment),
          
          if (canWrite) 
            _buildWriteCommentItem()
        ]),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Container(color: Colors.blue[50],
    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: const EdgeInsets.all(5.0),
      child: Column(children: [
       Row(children: [
        Text(comment.nick),
        Text(_getDateStr(comment.editTime)),
        Spacer(),
        IconButton(
          tooltip: "신고하기",
          icon: Icon(Icons.not_interested),
          iconSize: 35,
          onPressed: () {
            // 신고하기
          },
        )
      ]),
      Divider(thickness: 1),
      Text(comment.comment)
    ]));
  }

  Widget _buildWriteCommentItem() {
    return Container(color: Colors.blue[50],
    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: const EdgeInsets.all(5.0),
      child: Column(children: [
      Container(color: Colors.blue[50],
      child: Row(children: [
        SizedBox(width: 100, child: TextField(obscureText: true, obscuringCharacter: "익명의 캠퍼",)),
        Spacer(),
        ElevatedButton(
                onPressed: () async {
                  // 등록하기
                },
                child: Text("등록하기"),
              )
      ])),
      Divider(thickness: 1),
      TextField(obscureText: true, obscuringCharacter: "댓글...",)
    ])
    );
  }

  String _getDateStr(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    final String formatted = formatter.format(date);
    return formatted;
  }
}
