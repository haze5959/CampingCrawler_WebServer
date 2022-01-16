import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/PostItem.dart';

// 게시판 리스트에서 보여질 뷰
class PostFeedItem extends PostItem {
  final Post info;

  PostFeedItem(this.info) : super(info);

  Widget buildContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      info.title != null ? _buildBodyWithTitle() : _buildBody(),
      const Divider(height: 1),
      buildBottomInfo()
    ]);
  }

  Widget _buildBody() {
    return Padding(
        padding: const EdgeInsets.all(CARD_MARGIN),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          mainAxisSize: MainAxisSize.min,
        children: [
          buildTopInfo(),
          SizedBox(height: CARD_MARGIN),
          Text(
            "${info.body}",
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.fade,
            maxLines: 4,
          ),
        ]));
  }

  Widget _buildBodyWithTitle() {
    return Padding(
        padding: const EdgeInsets.all(CARD_MARGIN),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          mainAxisSize: MainAxisSize.min,
          children: [
          buildTopInfo(),
          SizedBox(height: CARD_MARGIN),
          Text(
            "${info.title}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            overflow: TextOverflow.fade,
            maxLines: 2,
          ),
          SizedBox(height: CARD_MARGIN),
          Text(
            "${info.body}",
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.fade,
            maxLines: 4,
          )
        ]));
  }
}
