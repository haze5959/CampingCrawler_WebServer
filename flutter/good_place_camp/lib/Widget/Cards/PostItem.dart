import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Utils/DateUtils.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

abstract class PostItem extends StatelessWidget {
  final Post info;

  PostItem(this.info);

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
            child: buildContent()),
      ),
    );
  }

  Widget buildContent();

  Widget buildTopInfo() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text(
                  info.getPostType().toPostTypeString(),
                  style: const TextStyle(fontSize: 12),
                ))),
        const Spacer(),
        Text(getRemainTime(info.updatedAt ?? DateTime.now()),
            style: TextStyle(fontSize: 14, color: Colors.grey))
      ]),
      SizedBox(height: CARD_MARGIN),
      Row(children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey,
          child: ClipOval(
              child: Icon(Icons.account_circle_outlined,
                  size: 30, color: Colors.white)
              // Image.asset(
              //   'images/girl.jpg',
              //   height: 14,
              //   width: 14,
              //   fit: BoxFit.cover,
              // ),
              ),
        ),
        SizedBox(width: 7),
        Text(
          "${info.nick}",
          style: TextStyle(fontSize: 14, color: Colors.grey),
          maxLines: 1,
        ),
      ])
    ]);
  }

  Widget buildBottomInfo() {
    return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: CARD_MARGIN, vertical: 10),
        child: Row(children: <Widget>[
          _goodCountWidget(),
          const SizedBox(width: CARD_MARGIN),
          _commentCountWidget()
        ]));
  }

  Widget _goodCountWidget() {
    final text = info.commentCount == 0 ? "good".tr : "${info.commentCount}";

    return Row(children: <Widget>[
      const Icon(Icons.thumb_up_alt_outlined, size: 14, color: Colors.grey),
      const SizedBox(width: 3),
      Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    ]);
  }

  Widget _commentCountWidget() {
    final text =
        info.commentCount == 0 ? "write_comment".tr : "${info.commentCount}";

    return Row(children: <Widget>[
      const Icon(Icons.comment_outlined, size: 14, color: Colors.grey),
      const SizedBox(width: 3),
      Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    ]);
  }
}
