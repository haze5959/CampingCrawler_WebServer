import 'dart:html';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/PostDetailContoller.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostDetailPage extends StatelessWidget {
  final int id;
  final String pw;

  PostDetailPage({this.id, this.pw});

  @override
  Widget build(BuildContext context) {
    final PostDetailContoller c = PostDetailContoller(id: id, pw: pw);

    return Scaffold(
      appBar: AppBar(
        title: Text("게시판"),
      ),
      body: Obx(() => c.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: _buildContent(context, c.posts, c.commentList))),
    );
  }

  Widget _buildContent(BuildContext context, Post posts, List<Comment> commentList) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.subtitle1.copyWith(color: Colors.white);
    final addrStyle = theme.textTheme.caption;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 184,
        child: Stack(
          children: [
            Positioned.fill(
              child: Ink.image(
                image: AssetImage('assets/Camp_Default.png'),
                fit: BoxFit.fitHeight,
                child: Container(),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 16,
              right: 16,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    posts.type.toPostTypeString(),
                    style: titleStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${posts.title}",
              style: theme.textTheme.headline4,
            ),
            Text("닉네임: ${posts.nick}", style: theme.textTheme.subtitle1),
            Text("작성일: ${_getDateStr(posts.editTime)}",
                style: theme.textTheme.caption),
            const Divider(thickness: 1),
            SizedBox(height: 20),
            Text("${posts.body}", style: theme.textTheme.headline6),
            SizedBox(height: 20),
            // 코맨트 만들어라!!
          ],
        ),
      ),
    ]);
  }

  String _getDateStr(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    final String formatted = formatter.format(date);
    return formatted;
  }
}
