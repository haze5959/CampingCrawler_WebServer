import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/PostDetailContoller.dart';

class PostWritePage extends StatelessWidget {
  final int id;

  PostWritePage({this.id});

  @override
  Widget build(BuildContext context) {
    final PostDetailContoller c = PostDetailContoller(id: id);

    TextEditingController titleControler = new TextEditingController();
    TextEditingController bodyControler = new TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: Text('Create Post'),
        ),
        body: new Container(
          margin: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: new Column(
            children: [
              new TextField(
                controller: titleControler,
                decoration: InputDecoration(
                    hintText: "title....", labelText: 'Post Title'),
              ),
              new TextField(
                controller: bodyControler,
                decoration: InputDecoration(
                    hintText: "body....", labelText: 'Post Body'),
              ),
              new ElevatedButton(
                onPressed: () async {
                  print(titleControler.text);
                  print(bodyControler.text);
                },
                child: const Text("Create"),
              )
            ],
          ),
        ));
  }
}
