import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';

class GPCAppBar extends AppBar {
  GPCAppBar()
      : super(
            title: Container(
                constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                child: Row(children: <Widget>[Text("명당캠핑"), Spacer()]))) {}
}
