import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Utils/DateUtils.dart';
import 'package:good_place_camp/Constants.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final void Function(Comment) removeHandler;

  CommentWidget({required this.comment, required this.removeHandler});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  color: Colors.blueGrey[50],
                  child: Row(children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(comment.nick,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
                    Text(getRemainTime(comment.updatedAt ?? DateTime.now()),
                        style: TextStyle(fontSize: 12)),
                    const Spacer(),
                    if (comment.nick == Constants.user.value.info.nick)
                      IconButton(
                        tooltip: "dialog_delete".tr(),
                        color: Colors.grey,
                        icon: const Icon(Icons.delete),
                        iconSize: 20,
                        onPressed: () {},
                      )
                    else
                      IconButton(
                        tooltip: "dialog_report".tr(),
                        color: Colors.grey,
                        icon: const Icon(Icons.report_gmailerrorred_outlined),
                        iconSize: 20,
                        onPressed: () {
                          showReportAlert(
                              "comment_${comment.id}", "comment".tr());
                        },
                      )
                  ])),
              Container(color: Colors.black12, height: 1),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(comment.comment))
            ])));
  }
}

class CommentWriteWidget extends StatelessWidget {
  final String nick;
  final TextEditingController bodyControler;
  final void Function() addHandler;

  CommentWriteWidget(
      {required this.nick,
      required this.bodyControler,
      required this.addHandler});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Column(children: [
              Container(
                  color: Colors.blueGrey[50],
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'nick'.tr(),
                            style: const TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.w300,
                                fontSize: 10),
                          ),
                          Text(
                            nick,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          )
                        ]),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => addHandler(),
                      child: Text("dialog_registration").tr(),
                    )
                  ])),
              Container(color: Colors.black12, height: 1),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: bodyControler,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'comment'.tr() + "...",
                        labelText: 'comment'.tr()),
                  ))
            ])));
  }
}
