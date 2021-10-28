import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/PostWriteContoller.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/UserInfoPage.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostWritePage extends GetView<PostWriteContoller> {
  final children = <int, Widget>{
    0: Text(PostType.request.toPostTypeString()),
    1: Text(PostType.question.toPostTypeString()),
    2: Text(PostType.secret.toPostTypeString()),
  };

  final PostWriteContoller c = PostWriteContoller();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostWriteContoller>(
        init: c,
        builder: (_) {
          return Scaffold(
              appBar: AppBar(
                title: Text('새글 작성하기'),
              ),
              body: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: Obx(() => Stack(children: [
                        SingleChildScrollView(
                            physics: ClampingScrollPhysics(),
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      child: Text(
                                          "작성자: ${Constants.user.value.isLogin ? Constants.user.value.info.nick : '익명의 캠퍼'}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                      onPressed: () {
                                        if (!Constants.user.value.isLogin) {
                                          showRequiredLoginAlert();
                                        } else {
                                          Get.to(UserInfoPage());
                                        }
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    SizedBox(
                                      width: 300,
                                      child: CupertinoSegmentedControl<int>(
                                        padding: EdgeInsets.zero,
                                        children: children,
                                        onValueChanged: (int newValue) {
                                          if (newValue == 2) {
                                            if (!Constants.user.value.isLogin) {
                                              showRequiredLoginAlert();
                                              c.postType.value = 0;
                                              return;
                                            }
                                          }

                                          c.postType.value = newValue;
                                        },
                                        groupValue: c.postType.value,
                                      ),
                                    ),
                                    if (c.postType.value == 2)
                                      Text("ℹ️ 비밀글은 작성자와 관리자만 확인할 수 있습니다."),
                                    TextField(
                                      controller: c.titleControler,
                                      decoration: InputDecoration(
                                          hintText: "제목", labelText: '제목'),
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      controller: c.bodyControler,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                          hintText: "내용", labelText: '본문'),
                                    ),
                                    SizedBox(height: 40),
                                    Center(
                                        child: ElevatedButton(
                                      onPressed: c.makePosts,
                                      child: Text("등록하기"),
                                    ))
                                  ],
                                ))),
                        if (c.isLoading.value)
                          Center(child: CircularProgressIndicator())
                      ]))));
        });
  }
}
