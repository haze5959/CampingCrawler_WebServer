import 'package:flutter/material.dart';

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
