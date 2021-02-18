import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/PostDetailContoller.dart';

class PostDetailPage extends StatelessWidget {
  final int id;

  PostDetailPage({this.id});

  @override
  Widget build(BuildContext context) {
    final PostDetailContoller c = PostDetailContoller(id: id);

    return Scaffold(
      appBar: AppBar(
        title: Text("게시판"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("ㄴㄹㄴㄹㄴㄹㄴㄹㄴㄹㄴ")
          ],
        ),
      ),
    );
  }
}
