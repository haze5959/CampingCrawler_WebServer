import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

// Utils
import 'package:good_place_camp/Utils/DateUtils.dart';

class CalenderWidget extends StatelessWidget {
  final bool isVertical;

  CalenderWidget({required this.isVertical});

  @override
  Widget build(context) {
    return GetBuilder<HomeController>(
        builder: (s) => Container(
            padding: EdgeInsets.only(bottom: 10),
            alignment: Alignment.center,
            child: Column(children: [
              isVertical
                  ? _buildVerticalCalendar(s, context)
                  : _buildHorizenCalendar(s, context),
              SizedBox(height: 10),
              _buildEventsExLabel()
            ])));
  }

  Widget _buildHorizenCalendar(HomeController s, BuildContext context) {
    return Scrollbar(
        child: SingleChildScrollView(
            padding: EdgeInsets.only(right: 10),
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [0, 1, 2, 3]
                    .map((index) => Row(children: <Widget>[
                          SizedBox(width: 10),
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
                                      locale: Localizations.localeOf(context)
                                          .languageCode,
                                      focusedDay:
                                          addMonths(DateTime.now(), index),
                                      firstDay: _getFirstDay(index),
                                      lastDay: _getLastDay(index),
                                      eventLoader: (day) {
                                        return s.getEventsForDay(day);
                                      },
                                      holidayPredicate: (day) {
                                        return s.holidays.containsKey(day);
                                      },
                                      availableGestures: AvailableGestures.none,
                                      calendarStyle: CalendarStyle(
                                        outsideDaysVisible: false,
                                      ),
                                      headerStyle: HeaderStyle(
                                          titleCentered: true,
                                          formatButtonVisible: false,
                                          leftChevronVisible: false,
                                          rightChevronVisible: false),
                                      calendarBuilders: CalendarBuilders(
                                        selectedBuilder: (context, date, _) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _isToday(date)
                                                    ? Color(0xFF9FA8DA)
                                                    : null),
                                            margin: const EdgeInsets.all(6.0),
                                            alignment: Alignment.center,
                                            child: Text('${date.day}',
                                                style: _isToday(date)
                                                    ? TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.0,
                                                      )
                                                    : _isWeekend(date,
                                                            s.holidays.keys)
                                                        ? TextStyle(
                                                            color: Colors.red)
                                                        : null),
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

  Widget _buildVerticalCalendar(HomeController s, BuildContext context) {
    return Column(
        children: [0, 1, 2, 3]
            .map((index) => Column(children: <Widget>[
                  ClipRect(
                      child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5)),
                              child: Container(
                                  width: CALENDER_WIDTH,
                                  child: TableCalendar(
                                    locale: Localizations.localeOf(context)
                                        .languageCode,
                                    focusedDay:
                                        addMonths(DateTime.now(), index),
                                    firstDay: _getFirstDay(index),
                                    lastDay: _getLastDay(index),
                                    eventLoader: (day) {
                                      return s.getEventsForDay(day);
                                    },
                                    holidayPredicate: (day) {
                                      return s.holidays.containsKey(day);
                                    },
                                    availableGestures: AvailableGestures.none,
                                    calendarStyle: CalendarStyle(
                                      outsideDaysVisible: false,
                                    ),
                                    headerStyle: HeaderStyle(
                                        titleCentered: true,
                                        formatButtonVisible: false,
                                        leftChevronVisible: false,
                                        rightChevronVisible: false),
                                    calendarBuilders: CalendarBuilders(
                                      selectedBuilder: (context, date, _) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _isToday(date)
                                                  ? const Color(0xFF9FA8DA)
                                                  : null),
                                          margin: const EdgeInsets.all(6.0),
                                          alignment: Alignment.center,
                                          child: Text('${date.day}',
                                              style: _isToday(date)
                                                  ? TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                    )
                                                  : _isWeekend(
                                                          date, s.holidays.keys)
                                                      ? TextStyle(
                                                          color: Colors.red)
                                                      : null),
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
                                  ))))),
                  SizedBox(height: 10)
                ]))
            .toList());
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

    if (reservationInfoCount > 0) {
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.red[400],
            ),
            width: 20.0,
            height: 16.0,
            child: Center(
              child: Text(
                '$reservationInfoCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.blue[400],
            ),
            width: 20.0,
            height: 16.0,
            child: Center(
              child: Text(
                '$dateInfoCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.blue[400],
        ),
        width: 20.0,
        height: 16.0,
        child: Center(
          child: Text(
            '$dateInfoCount',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildEventsExLabel() {
    return Container(
        constraints: BoxConstraints(maxWidth: MAX_WIDTH),
        child: Row(
          mainAxisAlignment:
              isVertical ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            TextButton(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.red[400],
                    ),
                    width: 20.0,
                    height: 16.0,
                    child: Center(
                      child: Text(
                        "N",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text("다음 예약일 오픈 캠핑장 표시",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      )),
                ],
              ),
              onPressed: () {
                showOneBtnAlert(
                    "다음 예약일정을 오픈하는 캠핑장들의 개수를 표시합니다.\n더 자세한 일정은 해당 캠핑장 상세화면에서 확인하실 수 있습니다.",
                    "확인",
                    () {});
              },
            ),
            SizedBox(width: 10),
            TextButton(
                child: Row(children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.blue[400],
                      ),
                      width: 20.0,
                      height: 16.0,
                      child: Center(
                        child: Text(
                          "N",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      )),
                  SizedBox(width: 5),
                  Text("예약 가능 캠핑장 표시",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ))
                ]),
                onPressed: () {
                  showOneBtnAlert(
                      "예약 가능한 캠핑장들의 개수를 표시합니다.\n예약정보 수집은 한시간 주기로 실행되며 이미 예약되었을 수도 있습니다.",
                      "확인",
                      () {});
                })
          ],
        ));
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    if (date.month == today.month && date.day == today.day) {
      return true;
    } else {
      return false;
    }
  }

  bool _isWeekend(DateTime date, Iterable<DateTime> holidays) {
    for (final holiday in holidays) {
      if (date.month == holiday.month && date.day == holiday.day) {
        return true;
      }
    }

    if (date.weekday == 6 || date.weekday == 7) {
      return true;
    } else {
      return false;
    }
  }

  DateTime _getFirstDay(int index) {
    final date = addMonths(DateTime.now(), index);
    return DateTime(date.year, date.month, 1);
  }

  DateTime _getLastDay(int index) {
    final date = addMonths(DateTime.now(), index);
    return DateTime(date.year, date.month, 31);
  }
}
