import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/PushContoller.dart';

// Models
import 'package:good_place_camp/Model/CampArea.dart';

// Widgets
import 'package:good_place_camp/Widget/ObxLoadingWidget.dart';

class PushSettingPage extends StatelessWidget {
  final PushContoller c = PushContoller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("notification_setting").tr(),
          actions: [],
        ),
        body: Stack(children: [
          GetBuilder<PushContoller>(
              init: c,
              builder: (c) => SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Center(
                        child: Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: _buildInfoContent())),
                  )),
          obxLoadingWidget(c.isLoading)
        ]));
  }

  Widget _buildInfoContent() {
    return Column(
      children: [
        const SizedBox(height: 50),
        _buildETCInfo(),
        const SizedBox(height: 50),
        _buildETCInfo(),
        const SizedBox(height: 50),
        _buildETCInfo(),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildETCInfo() {
    final favoriteArea = Constants.user.value.info.favoriteAreaList ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: const Text("notification_by_region",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black54))
                .tr()),
        const Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                tooltip: "notification_filter_region".tr(),
                icon: const Icon(Icons.filter_list_rounded),
                itemBuilder: (context) {
                  return [
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
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              const Text("notification_use_region",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                  .tr(),
              const Spacer(),
              Switch(
                value: c.pushInfo.usePushOnArea,
                onChanged: (value) {
                  c.pushInfo.usePushOnArea = value;
                  c.updatePushSetting();
                },
              )
            ])),
        AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (c.pushInfo.usePushOnArea) ...[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      const Text("notification_by_holiday",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15))
                          .tr(),
                      const Spacer(),
                      Switch(
                        value: c.pushInfo.useOnlyHolidayOnArea,
                        onChanged: (value) {
                          c.pushInfo.useOnlyHolidayOnArea = value;
                          c.updatePushSetting();
                        },
                      )
                    ])),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      const Text("notification_by_30days",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15))
                          .tr(),
                      const Spacer(),
                      Switch(
                        value: c.pushInfo.useOnlyInMonthOnArea,
                        onChanged: (value) {
                          c.pushInfo.useOnlyInMonthOnArea = value;
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
