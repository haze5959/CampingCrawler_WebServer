import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/TappableCampCardItem.dart';
import 'package:good_place_camp/Widget/Cards/PromotionCardItem.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class BottomSheetContent extends StatelessWidget {
  DateTime currentDate;
  RxList<SiteInfo> currentInfoList = <SiteInfo>[].obs;
  Map<DateTime, List<SiteInfo>> allEvents;
  Map<DateTime, List<String>> holidayList;

  final isFullScreen = false.obs;

  BottomSheetContent(
      {DateTime date,
      Map<DateTime, List<SiteInfo>> events,
      Map<DateTime, List<String>> holidays}) {
    currentDate = date;
    currentInfoList.value = events[date] ?? [];
    allEvents = events;
    holidayList = holidays;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: isFullScreen.value
            ? context.height - Get.context.mediaQueryPadding.top
            : context.height / 2 + 100,
        child: Scaffold(
            body: Column(
              children: [
                Container(
                    constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                    padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: Column(children: [
                      Row(children: <Widget>[
                        OutlinedButton.icon(
                          icon: Icon(Icons.chevron_left_outlined, size: 18),
                          label: Text(
                            "${DateFormat("MM-dd (EEE)", 'ko_KR').format(currentDate.add(Duration(days: -1)))}",
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          onPressed: () {
                            currentDate = currentDate.add(Duration(days: -1));
                            currentInfoList.value =
                                allEvents[currentDate] ?? <SiteInfo>[];
                          },
                        ),
                        Spacer(),
                        _buildSelectedWidget(currentDate),
                        Spacer(),
                        OutlinedButton.icon(
                          icon: Text(
                            "${DateFormat("MM-dd (EEE)", 'ko_KR').format(currentDate.add(Duration(days: 1)))}",
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          label: Icon(Icons.chevron_right_outlined, size: 18),
                          onPressed: () {
                            currentDate = currentDate.add(Duration(days: 1));
                            currentInfoList.value =
                                allEvents[currentDate] ?? <SiteInfo>[];
                          },
                        ),
                      ]),
                      SizedBox(height: 5),
                      Row(children: <Widget>[
                        Icon(Icons.info_outline, color: Colors.grey, size: 15),
                        SizedBox(width: 3),
                        Text(
                          "예약정보 수집은 원활한 예약 트래픽을 위하여 1시간에 한번 수집됩니다.",
                          style: TextStyle(
                              fontSize: Constants.isPhoneSize ? 11 : 15,
                              color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                    ])),
                Divider(thickness: 1),
                Expanded(
                  child: Container(
                      constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                      child: ListView.builder(
                        itemCount: currentInfoList.length + 1,
                        itemBuilder: (context, index) {
                          if (index < currentInfoList.length) {
                            return ListTile(
                                title: _buildListCell(
                                    context, currentInfoList[index]));
                          } else {
                            return ListTile(title: PromotionCardItem());
                          }
                        },
                      )),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                elevation: 0.0,
                child: Icon(Icons.expand),
                backgroundColor: Colors.lightGreen.shade400,
                onPressed: () {
                  isFullScreen.toggle();
                }))));
  }

  Widget _buildSelectedWidget(DateTime currentDate) {
    for (final key in holidayList.keys) {
      if (key.month == currentDate.month && key.day == currentDate.day) {
        final holidayName = holidayList[key][0];
        return Text(
          Constants.isPhoneSize
              ? "${DateFormat("MM-dd (EEE)", 'ko_KR').format(currentDate)} $holidayName"
              : "${DateFormat("yyyy-MM-dd (EEE)", 'ko_KR').format(currentDate)} $holidayName",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[400]),
        );
      }
    }

    if (currentDate.weekday == 6 || currentDate.weekday == 7) {
      return Text(
        Constants.isPhoneSize
            ? "${DateFormat("MM-dd (EEE)", 'ko_KR').format(currentDate)}"
            : "${DateFormat("yyyy-MM-dd (EEE)", 'ko_KR').format(currentDate)}",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[400]),
      );
    }

    return Text(
      Constants.isPhoneSize
          ? "${DateFormat("MM-dd (EEE)", 'ko_KR').format(currentDate)}"
          : "${DateFormat("yyyy-MM-dd (EEE)", 'ko_KR').format(currentDate)}",
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildListCell(BuildContext context, SiteInfo siteInfo) {
    return TappableCampCardItem(siteInfo: siteInfo);
  }
}
