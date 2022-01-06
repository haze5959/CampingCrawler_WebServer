import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:good_place_camp/Constants.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

// Utils
import 'package:good_place_camp/Utils/DateUtils.dart';

abstract class CalenderInterface extends GetxController {
  Map<DateTime, List<String>> holidays = Map<DateTime, List<String>>();
  List<SiteInfo> getEventsForDay(DateTime day);
  void onDaySelected(DateTime selectDay, DateTime _);
}

class CalenderWidget<Controller extends CalenderInterface>
    extends StatelessWidget {
  final Controller controller;
  final bool isOneCampSite;

  CalenderWidget({required this.controller, this.isOneCampSite = false});

  @override
  Widget build(context) {
    return GetBuilder<Controller>(
        init: controller,
        builder: (s) => Container(
            padding: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.center,
            child: Column(children: [
              _buildHorizenCalendar(s),
              const SizedBox(height: 10),
              _buildEventsExLabel()
            ])));
  }

  Widget _buildHorizenCalendar(Controller s) {
    return Scrollbar(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [0, 1, 2, 3]
                    .map((index) => Row(children: <Widget>[
                          const SizedBox(width: 10),
                          ClipRect(
                              child: BackdropFilter(
                            filter:
                                ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5)),
                                child: Container(
                                    width: CALENDER_WIDTH,
                                    child: TableCalendar(
                                      locale: "ko_KR",
                                      daysOfWeekHeight: 25,
                                      focusedDay:
                                          addMonths(DateTime.now(), index),
                                      firstDay: _getFirstDay(index),
                                      lastDay: _getLastDay(index),
                                      eventLoader: s.getEventsForDay,
                                      holidayPredicate: s.holidays.containsKey,
                                      availableGestures: AvailableGestures.none,
                                      calendarStyle: const CalendarStyle(
                                        outsideDaysVisible: false,
                                        weekendTextStyle:
                                            const TextStyle(color: Colors.red),
                                      ),
                                      headerStyle: const HeaderStyle(
                                          titleCentered: true,
                                          formatButtonVisible: false,
                                          leftChevronVisible: false,
                                          rightChevronVisible: false),
                                      calendarBuilders: CalendarBuilders(
                                        holidayBuilder:
                                            (context, date, events) {
                                          return Container(
                                            margin: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: Text('${date.day}',
                                                style: const TextStyle(
                                                    color: Colors.red)),
                                          );
                                        },
                                        markerBuilder: (context, date, events) {
                                          if (events.isNotEmpty) {
                                            return Positioned(
                                              right: 1,
                                              bottom: 1,
                                              child: _buildEventsMarker(
                                                  date, events),
                                            );
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      onDaySelected: s.onDaySelected,
                                      rowHeight: CALENDER_WIDTH / 6,
                                    ))),
                          )),
                        ]))
                    .toList())));
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    var dateInfoCount = 0;
    var reservationInfoCount = 0;

    for (final event in events) {
      if (event is SiteDateInfo) {
        dateInfoCount += 1;
      } else {
        reservationInfoCount += 1;
      }
    }

    return Row(
      children: [
        if (reservationInfoCount > 0)
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.redAccent,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(5.0)),
            ),
            width: 20.0,
            height: 16.0,
            child: Center(
              child: isOneCampSite
                  ? const Icon(Icons.date_range_outlined,
                      size: 12, color: Colors.white)
                  : Text(
                      '$reservationInfoCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
            ),
          ),
        if (dateInfoCount > 0)
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.blueAccent,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(5.0)),
            ),
            width: 20.0,
            height: 16.0,
            child: Center(
              child: isOneCampSite
                  ? const Icon(Icons.date_range_outlined,
                      size: 12, color: Colors.white)
                  : Text(
                      '$dateInfoCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
            ),
          )
        else
          const SizedBox(width: 20.0, height: 16.0)
      ],
    );
  }

  Widget _buildEventsExLabel() {
    return Container(
        constraints: const BoxConstraints(maxWidth: MAX_WIDTH),
        height: 30,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.redAccent,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(5.0)),
                        ),
                        width: 20.0,
                        height: 16.0,
                        child: Center(
                          child: Text(
                            "N",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text("camp_next_open_indicator".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          )),
                    ],
                  ),
                  onPressed: () {
                    showOneBtnAlert(
                        "camp_next_open_msg".tr, "confirm".tr, () {});
                  },
                ),
                const SizedBox(width: 10),
                TextButton(
                    child: Row(children: [
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.blueAccent,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(5.0)),
                          ),
                          width: 20.0,
                          height: 16.0,
                          child: const Center(
                            child: const Text(
                              "N",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                          )),
                      const SizedBox(width: 5),
                      Text("camp_avail_reservation_indicator".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ))
                    ]),
                    onPressed: () {
                      showOneBtnAlert(
                          "camp_avail_reservation_msg".tr, "confirm".tr, () {});
                    })
              ],
            )));
  }

  DateTime _getFirstDay(int index) {
    final date = addMonths(DateTime.now(), index);
    return DateTime.utc(date.year, date.month, index == 0 ? date.day : 1);
  }

  DateTime _getLastDay(int index) {
    final date = addMonths(DateTime.now(), index);
    return DateTime.utc(date.year, date.month, 31);
  }
}
