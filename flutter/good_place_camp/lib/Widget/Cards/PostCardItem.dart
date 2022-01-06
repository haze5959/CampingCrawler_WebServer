import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostCardItem extends StatelessWidget {
  final Post info;

  PostCardItem(this.info);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: CARD_WIDTH,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if (info.getPostType() == PostType.secret) {
              if (!Constants.user.value.isLogin) {
                showRequiredLoginAlert();
              } else {
                Get.toNamed("/board/detail/${info.id!}",
                    parameters: {"is_secret": "true"});
              }
            } else {
              Get.toNamed("/board/detail/${info.id!}");
            }
          },
          splashColor: Get.theme.colorScheme.onSurface.withOpacity(0.12),
          highlightColor: Colors.transparent,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final textTheme = Get.theme.textTheme;
    final descriptionStyle = textTheme.bodyText2;
    final addrStyle = textTheme.caption;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 184,
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: 15,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: Text(
                        info.getPostType().toPostTypeString(),
                        style: const TextStyle(fontSize: 12),
                      ))),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(children: <Widget>[
                  const Icon(Icons.comment_outlined, size: 18),
                  const SizedBox(width: 3),
                  Text(
                    "${info.commentCount}",
                    style: textTheme.subtitle1,
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
          style: descriptionStyle!,
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
