import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/PostItem.dart';

class PostCardItem extends PostItem {
  final Post info;

  PostCardItem(this.info) : super(info);

  Widget buildContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      info.title.length > 0 ? _buildBodyWithTitle() : _buildBody(),
      const Spacer(),
      const Divider(height: 1),
      buildBottomInfo()
    ]);
  }

  Widget _buildBody() {
    return Padding(
        padding: const EdgeInsets.all(CARD_MARGIN),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          buildTopInfo(),
          SizedBox(height: CARD_MARGIN),
          Text(
            "${info.title}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            overflow: TextOverflow.fade,
            maxLines: 2,
          )
        ]));
  }
}
