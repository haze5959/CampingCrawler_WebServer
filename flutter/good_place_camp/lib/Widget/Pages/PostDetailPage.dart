import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/PostDetailContoller.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostDetailPage extends StatelessWidget {
  final int id;

  PostDetailPage({this.id});

  @override
  Widget build(BuildContext context) {
    final PostDetailContoller c = PostDetailContoller(id: id);

    return Scaffold(
      appBar: AppBar(
        title: Text("게시판"),
      ),
      body: Center(
        child: c.isLoading.value ? Center(child: CircularProgressIndicator()) : _buildContent(context, c.posts)
      ),
    );
  }

  Widget _buildContent(BuildContext context, Post posts) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.subtitle1.copyWith(color: Colors.white);
    final descriptionStyle = theme.textTheme.bodyText2;
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
            Positioned(
              top: 16,
              right: 16,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(children: <Widget>[
                  Icon(Icons.comment_outlined, size: 18),
                  SizedBox(width: 3),
                  Text(
                    "${posts.commentCount}",
                    style: theme.textTheme.subtitle1,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: DefaultTextStyle(
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: descriptionStyle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${posts.title}",
                style: descriptionStyle,
                overflow: TextOverflow.fade,
                maxLines: 1,
              ),
              Text("${posts.nick}", style: addrStyle)
            ],
          ),
        ),
      ),
    ]);
  }
}
