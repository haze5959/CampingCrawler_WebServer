import 'package:flutter/material.dart';

// Repository
import 'package:good_place_camp/Repository/PostsRepository.dart';

void showOneBtnAlert(BuildContext context, String msg, String btnText,
    Function() confirmAction) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            msg,
          ),
          actions: [
            TextButton(
              child: Text(btnText),
              onPressed: () {
                Navigator.of(context).pop();
                confirmAction();
              },
            )
          ],
        );
      });
}

void showPwAlert(
    BuildContext context, String msg, Function(String pw) confirmAction) {
  TextEditingController pwControler = new TextEditingController();

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              msg,
            ),
            TextField(
              controller: pwControler,
              decoration:
                  InputDecoration(hintText: "패스워드...", labelText: '패스워드'),
            )
          ]),
          actions: [
            TextButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
                confirmAction(pwControler.text);
              },
            )
          ],
        );
      });
}

void showReportAlert(BuildContext context, String id) {
  TextEditingController bodyControler = new TextEditingController();
  PostsRepository postRepo = PostsRepository();

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: bodyControler,
              decoration:
                  InputDecoration(hintText: "신고 내용...", labelText: '신고 내용'),
            )
          ]),
          actions: [
            TextButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("확인"),
              onPressed: () async {
                final result =
                    await postRepo.postReportWith(id, bodyControler.text);
                if (result.hasError) {
                  showOneBtnAlert(context, result.statusText, "닫기", () {});
                  return;
                } else if (!result.body.result) {
                  showOneBtnAlert(context, result.body.msg, "닫기", () {});
                  return;
                }

                Navigator.of(context).pop();

                showOneBtnAlert(context, "신고되었습니다.", "닫기", () {});
              },
            )
          ],
        );
      });
}
