import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/GPCAppBar.dart';
import 'package:good_place_camp/Widget/Pages/PostWritePage.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/PostCardItem.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostListPage extends StatelessWidget {
  final bool isNotice; // 공지사항 뷰인지

  PostListPage({this.isNotice});

  @override
  Widget build(BuildContext context) {
    final HomeController c = Get.find();
    final list = isNotice ? c.noticeList : c.postList;

    return _build(list);
  }

  Scaffold _build(List<Post> list) {
    if (isNotice) {
      return Scaffold(
          appBar: GPCAppBar(pageName: "공지사항", showFilter: false),
          body: Center(
            child: Container(
                constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                child: Scrollbar(
                    child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: _buildListCell(list[index]),
                    );
                  },
                ))),
          ));
    } else {
      return Scaffold(
          appBar: GPCAppBar(pageName: "요청/문의", showFilter: false),
          body: Center(
            child: Container(
                constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                child: Scrollbar(
                    child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: _buildListCell(list[index]),
                    );
                  },
                ))),
          ),
          floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              tooltip: "새 글쓰기",
              child: Icon(Icons.edit),
              backgroundColor: Colors.lightGreen.shade400,
              onPressed: () {
                Get.to(PostWritePage());
              }));
    }
  }

  Widget _buildListCell(Post info) {
    return PostCardItem(info: info);
  }
}
