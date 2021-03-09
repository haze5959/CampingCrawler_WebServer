import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';


// 웹이면 스마트폰을 통해 명당자리 알림을 받으세요
// 모바일이면 매월 2천원 구독으로 쏼라쏼라
class PushPromotionPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PushPromotionPage"),
        actions: [
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: Text("PushPromotionPage"),
              onPressed: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}
