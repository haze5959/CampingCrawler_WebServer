import 'package:good_place_camp/Widget/Sheets/GPCSheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/TappableCampCardItem.dart';
import 'package:good_place_camp/Widget/Cards/PromotionCardItem.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class SiteDetailListSheet extends GPCSheet {
  final Map<DateTime, List<SiteInfo>> _allEvents;

  SiteDetailListSheet(
    Rx<DateTime> currentDate,
    Map<DateTime, List<String>> holidayList,
    this._allEvents,
  ) : super(currentDate, holidayList);

  Widget contentsScrollWidget(ScrollController? controller) {
    final currentEvents = _allEvents[currentDate.value] ?? [];
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
                color: Colors.grey.shade50.withOpacity(0.95),
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
              color: Colors.grey.shade50.withOpacity(0.95),
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
