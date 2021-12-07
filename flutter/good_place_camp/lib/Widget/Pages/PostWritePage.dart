import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('board_wirte_new').tr(),
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
                      physics: const ClampingScrollPhysics(),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                child: Text(
                                    "writer".tr() +
                                        ": ${Constants.user.value.isLogin ? Constants.user.value.info.nick : 'default_nick'.tr()}",
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
                              const SizedBox(height: 20),
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
                                const Text("board_secret_info").tr(),
                              TextField(
                                controller: c.titleControler,
                                decoration: InputDecoration(
                                    hintText: "title".tr() + "...",
                                    labelText: 'title'.tr()),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: c.bodyControler,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                    hintText: "content".tr() + "...",
                                    labelText: 'content'.tr()),
                              ),
                              const SizedBox(height: 40),
                              Center(
                                  child: ElevatedButton(
                                onPressed: c.makePosts,
                                child: const Text("dialog_registration").tr(),
                              ))
                            ],
                          ))),
                  if (c.isLoading.value)
                    const Center(child: const CircularProgressIndicator())
                ]))));
  }
}
