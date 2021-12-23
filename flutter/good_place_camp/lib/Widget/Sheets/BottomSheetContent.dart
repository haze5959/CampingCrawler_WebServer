import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/TappableCampCardItem.dart';
import 'package:good_place_camp/Widget/Cards/PromotionCardItem.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class BottomSheetContent extends StatelessWidget {
  final Rx<DateTime> _currentDate;
  final Map<DateTime, List<SiteInfo>> _allEvents;
  final Map<DateTime, List<String>> _holidayList;

  BottomSheetContent(this._currentDate, this._allEvents, this._holidayList);

  @override
  Widget build(BuildContext context) {
    if (Constants.isPhoneSize) {
      return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Obx(() {
              final prevDate = _currentDate.value.add(Duration(days: -1));
              return Column(
                children: [
                  Container(
                      constraints: const BoxConstraints(maxWidth: MAX_WIDTH),
                      padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                      child: Column(children: [
                        Row(children: <Widget>[
                          OutlinedButton.icon(
                            icon: const Icon(Icons.chevron_left_outlined,
                                size: 18),
                            label: Text(
                              "${DateFormat("MM-dd (EEE)", 'ko_KR').format(prevDate)}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                            ),
                            onPressed: prevDate.isBefore(DateTime.now())
                                ? null
                                : () {
                                    _currentDate.value = prevDate;
                                  },
                          ),
                          const Spacer(),
                          _buildSelectedWidget(_currentDate.value),
                          const Spacer(),
                          OutlinedButton.icon(
                            icon: Text(
                              "${DateFormat("MM-dd (EEE)", 'ko_KR').format(_currentDate.value.add(Duration(days: 1)))}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                            ),
                            label: const Icon(Icons.chevron_right_outlined,
                                size: 18),
                            onPressed: () {
                              _currentDate.value =
                                  _currentDate.value.add(Duration(days: 1));
                            },
                          ),
                        ]),
                        const SizedBox(height: 5),
                        Row(children: <Widget>[
                          Icon(Icons.info_outline,
                              color: Colors.grey, size: 10),
                          const SizedBox(width: 3),
                          Text(
                            "camp_info_1".tr,
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]),
                      ])),
                  const Divider(thickness: 1),
                  Expanded(
                    child: _contentsScrollWidget(scrollController),
                  )
                ],
              );
            });
          });
    } else {
      final isFullScreen = false.obs;

      return Obx(() {
        final prevDate = _currentDate.value.add(Duration(days: -1));
        return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: isFullScreen.value
                ? context.height -
                    ((Get.context?.mediaQueryPadding.top ?? 0) + kToolbarHeight)
                : context.height / 2 + 100,
            child: Scaffold(
                body: Column(
                  children: [
                    Container(
                        constraints: const BoxConstraints(maxWidth: MAX_WIDTH),
                        padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                        child: Column(children: [
                          Row(children: <Widget>[
                            OutlinedButton.icon(
                              icon: const Icon(Icons.chevron_left_outlined,
                                  size: 18),
                              label: Text(
                                "${DateFormat("MM-dd (EEE)", 'ko_KR').format(prevDate)}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              onPressed: prevDate.isBefore(DateTime.now())
                                  ? null
                                  : () {
                                      _currentDate.value = prevDate;
                                    },
                            ),
                            const Spacer(),
                            _buildSelectedWidget(_currentDate.value),
                            const Spacer(),
                            OutlinedButton.icon(
                              icon: Text(
                                "${DateFormat("MM-dd (EEE)", 'ko_KR').format(_currentDate.value.add(Duration(days: 1)))}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              label: const Icon(Icons.chevron_right_outlined,
                                  size: 18),
                              onPressed: () {
                                _currentDate.value =
                                    _currentDate.value.add(Duration(days: 1));
                              },
                            ),
                          ]),
                          const SizedBox(height: 5),
                          Row(children: <Widget>[
                            Icon(Icons.info_outline,
                                color: Colors.grey, size: 15),
                            const SizedBox(width: 3),
                            Text(
                              "camp_info_1".tr,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                        ])),
                    const Divider(thickness: 1),
                    Expanded(
                      child: Container(
                          constraints:
                              const BoxConstraints(maxWidth: MAX_WIDTH),
                          child: _contentsScrollWidget(null)),
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                    elevation: 0.0,
                    child: const Icon(Icons.expand),
                    backgroundColor: Colors.lightGreen.shade400,
                    onPressed: () {
                      isFullScreen.toggle();
                    })));
      });
    }
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
                      fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
                Text(
                  holidayName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                )
              ])
            : Text(
                "${DateFormat("yyyy-MM-dd (EEE)", 'ko_KR').format(currentDate)} $holidayName",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.redAccent),
              );
      }
    }

    if (currentDate.weekday == 6 || currentDate.weekday == 7) {
      return Text(
        Constants.isPhoneSize
            ? "${DateFormat("MM-dd (EEE)", 'ko_KR').format(currentDate)}"
            : "${DateFormat("yyyy-MM-dd (EEE)", 'ko_KR').format(currentDate)}",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
      );
    }

    return Text(
      Constants.isPhoneSize
          ? "${DateFormat("MM-dd (EEE)", 'ko_KR').format(currentDate)}"
          : "${DateFormat("yyyy-MM-dd (EEE)", 'ko_KR').format(currentDate)}",
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _contentsScrollWidget(ScrollController? controller) {
    final currentEvents = _allEvents[_currentDate.value] ?? [];
    final List<SiteDateInfo> siteInfoList =
        currentEvents.whereType<SiteDateInfo>().toList();
    final List<ReservationInfo> reservationInfoList =
        currentEvents.whereType<ReservationInfo>().toList();

    return CustomScrollView(
      controller: controller,
      slivers: [
        // 예약 오픈 캠핑장
        if (reservationInfoList.length > 0) ...[
          SliverStickyHeader(
            header: Container(
                color: Colors.grey.shade50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                              "camp_next_open".tr +
                                  "(${reservationInfoList.length})",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.redAccent))),
                      const Divider(color: Colors.redAccent, thickness: 1)
                    ])),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final info = reservationInfoList[i];
                  return TappableReservationInfoCardItem(info: info);
                },
                childCount: reservationInfoList.length,
              ),
            ),
          ),
        ],

        // 예약 가능 캠핑장
        SliverStickyHeader(
          header: Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                            "camp_avail_reservation".tr +
                                "(${siteInfoList.length})",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.blueAccent))),
                    Divider(
                      color: Colors.blueAccent,
                      thickness: 1,
                    ),
                  ])),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                if (siteInfoList.length <= i) {
                  return PromotionCardItem();
                } else {
                  final info = siteInfoList[i];
                  return TappableCampCardItem(siteInfo: info);
                }
              },
              childCount: siteInfoList.length + 1,
            ),
          ),
        )
      ],
    );
  }
}
