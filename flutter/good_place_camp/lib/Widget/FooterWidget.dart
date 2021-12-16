import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FooterWidget extends StatelessWidget {
  final footerStyle = TextStyle(color: Colors.white);

  @override
  Widget build(context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        color: Colors.lightGreen.shade800,
        child: Column(children: [
          Text("footer_info".tr, style: footerStyle),
          const Divider(thickness: 1),
          Text("Copyright © All rights reserved. Created by OQ",
              style: footerStyle)
        ]));
  }
}
