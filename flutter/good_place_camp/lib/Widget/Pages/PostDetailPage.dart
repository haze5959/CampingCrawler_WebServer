import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/PostDetailContoller.dart';

// Widgets
import 'package:good_place_camp/Widget/Comments/CommentWidget.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostDetailPage extends StatelessWidget {
  final int id;
  final bool isSecret;

  PostDetailPage(this.id, {this.isSecret = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("board").tr(),
      ),
      body: GetBuilder<PostDetailContoller>(
          init: PostDetailContoller(id: id, isSecret: isSecret),
          builder: (c) => c.isLoading
              ? const Center(child: const CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      child: _buildContent(c, c.commentList)))),
    );
  }

  Widget _buildContent(PostDetailContoller c, List<Comment> commentList) {
    final textTheme = Get.theme.textTheme;
    final titleStyle = textTheme.subtitle1!.copyWith(color: Colors.white);
    final posts = c.posts!;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 184,
        child: Stack(
          children: [
            Positioned.fill(
              child: Ink.image(
                image: const AssetImage('assets/Camp_Default.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
            Positioned(
              top: 8,
              right: 16,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: posts.nick == Constants.user.value.info.nick
                    ? IconButton(
                        tooltip: "dialog_delete".tr(),
                        color: Colors.grey,
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showTwoBtnAlert(
                              "dialog_delete_confirm".tr(args: ["boards".tr()]),
                              "delete".tr(), () async {
                            final isSuccess = await c.deletePosts();
                            if (isSuccess) {
                              showOneBtnAlert(
                                  "dialog_delete_complete".tr(), "confirm".tr(),
                                  () {
                                Get.back();
                              });
                            }
                          });
                        },
                      )
                    : IconButton(
                        tooltip: "dialog_report".tr(),
                        color: Colors.grey,
                        icon: const Icon(Icons.report_gmailerrorred_outlined),
                        onPressed: () {
                          showReportAlert("posts_$id", "boards".tr());
                        },
                      ),
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
                  decoration: const BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    posts.toPostTypeString(),
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
              style: textTheme.headline4,
            ),
            Text("nick".tr() + ": ${posts.nick}", style: textTheme.subtitle1),
            Text(
                "create_date".tr() +
                    ": ${_getDateStr(posts.updatedTime ?? DateTime.now())}",
                style: textTheme.caption),
            const Divider(thickness: 1),
            const SizedBox(height: 20),
            Text("${posts.body}", style: textTheme.headline6),
            const SizedBox(height: 40),
            CommentWidget(postId: id, commentList: commentList.obs),
            const SizedBox(height: 40),
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
