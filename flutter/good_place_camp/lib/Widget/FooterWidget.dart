import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  final footerStyle = TextStyle(color: Colors.white);

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      color: Colors.lightGreen.shade800,
        child: Column(children: [
          Text("명당캠핑은 통신판매중개자이며 통신판매의 당사자가 아닙니다. 따라서 상품·거래정보 및 거래에 대하여 책임을 지지않습니다.", style: footerStyle),
      const Divider(thickness: 1),
      Text("Copyright © All rights reserved. Created by OQ", style: footerStyle)
    ]));
  }
}
