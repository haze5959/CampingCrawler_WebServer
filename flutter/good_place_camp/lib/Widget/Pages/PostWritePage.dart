import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// Controller
import 'package:good_place_camp/Controller/PostWriteContoller.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostWritePage extends StatelessWidget {
  final children = <int, Widget>{
    0: Text(PostType.request.toPostTypeString()),
    1: Text(PostType.question.toPostTypeString()),
    2: Text(PostType.secret.toPostTypeString()),
  };

  @override
  Widget build(BuildContext context) {
    final PostWriteContoller c = PostWriteContoller();

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
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 150,
                            child: TextField(
                              readOnly: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                              controller: c.nickControler,
                              decoration: InputDecoration(
                                  hintText: "닉네임", labelText: '닉네임'),
                            )),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 300,
                          child: CupertinoSegmentedControl<int>(
                            padding: EdgeInsets.zero,
                            children: children,
                            onValueChanged: (int newValue) {
                              c.postType.value = newValue;
                            },
                            groupValue: c.postType.value,
                          ),
                        ),
                        if (c.postType.value == 2)
                          Text("ℹ️ 비밀글은 운영자만 확인할 수 있습니다."),
                        TextField(
                          controller: c.titleControler,
                          decoration:
                              InputDecoration(hintText: "제목", labelText: '제목'),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: c.bodyControler,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration:
                              InputDecoration(hintText: "내용", labelText: '본문'),
                        ),
                        SizedBox(height: 20),
                        if (c.postType.value == 2)
                          TextFormField(
                            controller: c.pwControler,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                hintText: "숫자 6자리", labelText: '비밀번호'),
                          ),
                        SizedBox(height: 20),
                        Center(
                            child: ElevatedButton(
                          onPressed: c.makePosts,
                          child: Text("등록하기"),
                        ))
                      ],
                    ),
                  ),
                  if (c.isLoading.value)
                    Center(child: CircularProgressIndicator())
                ]))));
  }
}
