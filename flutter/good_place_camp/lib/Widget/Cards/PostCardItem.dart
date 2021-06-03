import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:flutter/cupertino.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/PostDetailPage.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostCardItem extends StatelessWidget {
  final Post info;

  PostCardItem({
    this.info,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: CARD_WIDTH,
          height: CARD_HEIGHT,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                if (info.type == PostType.secret) {
                  if (!Constants.user.value.isLogin) {
                    showRequiredLoginAlert();
                  } else {
                    Navigator.push<void>(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              PostDetailPage(id: info.id, isSecret: true)),
                    );
                  }
                } else {
                  Navigator.push<void>(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => PostDetailPage(id: info.id)),
                  );
                }
              },
              splashColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
              highlightColor: Colors.transparent,
              child: _buildContent(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
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
                    info.type.toPostTypeString(),
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
                    "${info.commentCount}",
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
                "${info.title}",
                style: descriptionStyle,
                overflow: TextOverflow.fade,
                maxLines: 1,
              ),
              Text(
                "${info.nick}",
                style: addrStyle,
                maxLines: 1,
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
