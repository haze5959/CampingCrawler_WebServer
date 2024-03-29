import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Constants.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/TappableCampCardItem.dart';
import 'package:good_place_camp/Widget/Cards/PromotionCardItem.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class BottomSheetContent extends StatelessWidget {
  final Rx<DateTime> _currentDate;
  final Map<DateTime, List<SiteInfo>> _allEvents;
  final Map<DateTime, List<String>> _holidayList;

  final isFullScreen = false.obs;

  BottomSheetContent(this._currentDate, this._allEvents, this._holidayList);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentEvents = _allEvents[_currentDate.value] ?? [];
      final List<SiteDateInfo> siteInfoList =
          currentEvents.whereType<SiteDateInfo>().toList();
      final List<ReservationInfo> reservationInfoList =
          currentEvents.whereType<ReservationInfo>().toList();
      return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: isFullScreen.value
              ? context.height - (Get.context?.mediaQueryPadding.top ?? 0)
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
                              "${DateFormat("MM-dd (EEE)", 'ko_KR').format(_currentDate.value.add(Duration(days: -1)))}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            onPressed: () {
                              _currentDate.value =
                                  _currentDate.value.add(Duration(days: -1));
                            },
                          ),
                          Spacer(),
                          _buildSelectedWidget(_currentDate.value),
                          Spacer(),
                          OutlinedButton.icon(
                            icon: Text(
                              "${DateFormat("MM-dd (EEE)", 'ko_KR').format(_currentDate.value.add(Duration(days: 1)))}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            label: Icon(Icons.chevron_right_outlined, size: 18),
                            onPressed: () {
                              _currentDate.value =
                                  _currentDate.value.add(Duration(days: 1));
                            },
                          ),
                        ]),
                        SizedBox(height: 5),
                        Row(children: <Widget>[
                          Icon(Icons.info_outline,
                              color: Colors.grey,
                              size: Constants.isPhoneSize ? 10 : 15),
                          SizedBox(width: 3),
                          Text(
                            "camp_info_1",
                            style: TextStyle(
                                fontSize: Constants.isPhoneSize ? 10 : 15,
                                color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ).tr(),
                        ]),
                      ])),
                  Divider(thickness: 1),
                  Expanded(
                    child: Container(
                        constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                        child: ListView(children: [
                          if (reservationInfoList.length > 0) ...[
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                    "camp_next_open".tr() +
                                        "(${reservationInfoList.length})",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.red[400]))),
                            Divider(
                              color: Colors.red[400],
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                            ),
                            for (final reservationInfo in reservationInfoList)
                              TappableReservationInfoCardItem(
                                  info: reservationInfo),
                          ],
                          if (siteInfoList.length > 0) ...[
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                    "camp_avail_reservation".tr() +
                                        "(${siteInfoList.length})",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.blue[400]))),
                            Divider(
                              color: Colors.blue[400],
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                            ),
                            for (final siteInfo in siteInfoList)
                              TappableCampCardItem(siteInfo: siteInfo),
                          ],
                          PromotionCardItem()
                        ])),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                  elevation: 0.0,
                  child: Icon(Icons.expand),
                  backgroundColor: Colors.lightGreen.shade400,
                  onPressed: () {
                    isFullScreen.toggle();
                  })));
    });
  }

  Widget _buildSelectedWidget(DateTime currentDate) {
    for (final key in _holidayList.keys) {
      if (key.month == currentDate.month && key.day == currentDate.day) {
        final holidayName = _holidayList[key]?[0] ?? "";
        return Constants.isPhoneSize
            ? Column(children: [
                Text(
                  DateFormat("MM-dd (EEE)", 'ko_KR').format(currentDate),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red[400]),
                ),
                Text(
                  holidayName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                )
              ])
            : Text(
                "${DateFormat("yyyy-MM-dd (EEE)", 'ko_KR').format(currentDate)} $holidayName",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red[400]),
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
}
