import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/UserInfoController.dart';
import 'package:good_place_camp/Model/CampUser.dart';

class UserInfoPage extends StatelessWidget {
  final UserInfoController c = UserInfoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("UserInfoPage"),
          actions: [],
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Center(
              child: Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Obx(() => _buildInfoContent(Constants.user.value)))),
        ));
  }

  Widget _buildInfoContent(CampUser user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildUserInfo(user),
        _buildSubscriptInfo(user),
        _buildETCInfo(user),
      ],
    );
  }

  Widget _buildUserInfo(CampUser user) {
    return Column(
      children: [
        Text("유저 정보"),
        Row(children: [
          // 닉네임 설정, 레벨
        ])
      ],
    );
  }

  Widget _buildSubscriptInfo(CampUser user) {
    return Column(
      children: [
        Text("구독 정보"),
        Row(children: [
          // 구독하러가기 or 푸시설정 바로가기
        ])
      ],
    );
  }

  Widget _buildETCInfo(CampUser user) {
    return Column(
      children: [
        Text("기타"),
        Row(children: [
          // SNS 연동, 로그아웃
        ])
      ],
    );
  }
}
