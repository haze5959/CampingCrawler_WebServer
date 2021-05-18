import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Model/PushInfo.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Controller
import 'package:good_place_camp/Controller/PushContoller.dart';

// Models
import 'package:good_place_camp/Model/CampArea.dart';

class PushSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PushContoller c = PushContoller();

    return GetBuilder<PushContoller>(
        init: c,
        builder: (_) {
          return Scaffold(
              appBar: AppBar(
                title: Text("푸시 설정"),
                actions: [],
              ),
              body: Obx(() => Stack(children: [
                    SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Center(
                          child: Container(
                              constraints: BoxConstraints(maxWidth: 500),
                              child: Obx(
                                  () => _buildInfoContent(c.pushInfo.value)))),
                    ),
                    if (c.isLoading.value)
                      Center(child: CircularProgressIndicator())
                  ])));
        });
  }

  Widget _buildInfoContent(PushInfo info) {
    return Column(
      children: [
        SizedBox(height: 50),
        _buildETCInfo(info),
        SizedBox(height: 50),
        _buildETCInfo(info),
        SizedBox(height: 50),
        _buildETCInfo(info),
        SizedBox(height: 50),
      ],
    );
  }

  Widget _buildETCInfo(PushInfo info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text("지역별",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black54))),
        Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              for (var area in info.favoriteArea)
                InputChip(
                  onPressed: () {},
                  onDeleted: () {},
                  avatar: const Icon(
                    Icons.directions_bike,
                    size: 20,
                    color: Colors.black54,
                  ),
                  deleteIconColor: Colors.black54,
                  label: Text(area.toAreaString()),
                )
            ])),
        SizedBox(height: 20),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Text("-",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Spacer(),
              // 탈퇴
              OutlinedButton(
                style: OutlinedButton.styleFrom(primary: Colors.black),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("탈퇴하기",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))
                      ]),
                ),
                onPressed: () async {
                  showTwoBtnAlert(Get.context, "정말 탈퇴하시겠습니까?ㅠ", "로그아웃",
                      () async {
                    final isSuccess = await user.signout();
                    if (isSuccess) {
                      showOneBtnAlert(
                          Get.context, "탈퇴되었습니다. \n이용해주셔서 감사합니다.", "확인", () {
                        Get.back();
                      });
                    }
                  });
                },
              )
            ]))
      ],
    );
  }
}
