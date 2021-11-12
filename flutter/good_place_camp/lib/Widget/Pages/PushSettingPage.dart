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
  final PushContoller c = PushContoller();

  @override
  Widget build(BuildContext context) {
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
    final favoriteArea = Constants.user.value.info.favoriteAreaList ?? [];
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
              for (var area in favoriteArea)
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
                ),
              PopupMenuButton<CampArea>(
                tooltip: "지역필터",
                icon: Icon(Icons.filter_list_rounded),
                itemBuilder: (context) {
                  return [
                    CheckedPopupMenuItem(
                      value: CampArea.all,
                      checked: favoriteArea.isEmpty,
                      child: Text(
                        CampArea.all.toAreaString(),
                      ),
                    ),
                    CheckedPopupMenuItem(
                      value: CampArea.seoul,
                      checked: favoriteArea.contains(CampArea.seoul),
                      child: Text(
                        CampArea.seoul.toAreaString(),
                      ),
                    ),
                    CheckedPopupMenuItem(
                      value: CampArea.gyeonggi,
                      checked: favoriteArea.contains(CampArea.gyeonggi),
                      child: Text(
                        CampArea.gyeonggi.toAreaString(),
                      ),
                    ),
                    CheckedPopupMenuItem(
                      value: CampArea.inchoen,
                      checked: favoriteArea.contains(CampArea.inchoen),
                      child: Text(
                        CampArea.inchoen.toAreaString(),
                      ),
                    ),
                    CheckedPopupMenuItem(
                      value: CampArea.chungnam,
                      checked: favoriteArea.contains(CampArea.chungnam),
                      child: Text(
                        CampArea.chungnam.toAreaString(),
                      ),
                    ),
                    CheckedPopupMenuItem(
                      value: CampArea.chungbuk,
                      checked: favoriteArea.contains(CampArea.chungbuk),
                      child: Text(
                        CampArea.chungbuk.toAreaString(),
                      ),
                    ),
                    CheckedPopupMenuItem(
                      value: CampArea.gangwon,
                      checked: favoriteArea.contains(CampArea.gangwon),
                      child: Text(
                        CampArea.gangwon.toAreaString(),
                      ),
                    ),
                  ];
                },
                onSelected: (area) => c.editArea(area),
              )
            ])),
        SizedBox(height: 20),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Text("지역별 알림 사용하기",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Spacer(),
              Switch(
                value: info.usePushOnArea,
                onChanged: (value) {
                  c.pushInfo.value.usePushOnArea = value;
                  c.updatePushSetting();
                },
              )
            ])),
        AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (info.usePushOnArea) ...[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      Text("주말/공휴일 빈자리만 알림",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Spacer(),
                      Switch(
                        value: info.useOnlyHolidayOnArea,
                        onChanged: (value) {
                          c.pushInfo.value.useOnlyHolidayOnArea = value;
                          c.updatePushSetting();
                        },
                      )
                    ])),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      Text("30일 내 자리만 알림",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Spacer(),
                      Switch(
                        value: info.useOnlyInMonthOnArea,
                        onChanged: (value) {
                          c.pushInfo.value.useOnlyInMonthOnArea = value;
                          c.updatePushSetting();
                        },
                      )
                    ])),
              ]
            ]))
      ],
    );
  }
}
