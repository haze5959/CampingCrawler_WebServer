import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
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

  CalenderWidget({this.isVertical});

  @override
  Widget build(context) {
    return GetBuilder<HomeController>(
        builder: (s) => Container(
            padding: EdgeInsets.only(bottom: 10),
            alignment: Alignment.center,
            child: isVertical
                ? _buildVerticalCalendar(s, context)
                : _buildHorizenCalendar(s, context)));
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
                                      initialSelectedDay:
                                          addMonths(DateTime.now(), index),
                                      calendarController:
                                          s.calendarControllerList[index],
                                      events: s.events,
                                      holidays: s.holidays,
                                      availableGestures: AvailableGestures.none,
                                      calendarStyle: CalendarStyle(
                                        outsideDaysVisible: false,
                                      ),
                                      headerStyle: HeaderStyle(
                                          centerHeaderTitle: true,
                                          formatButtonVisible: false,
                                          leftChevronVisible: false,
                                          rightChevronVisible: false),
                                      builders: CalendarBuilders(
                                        selectedDayBuilder: (context, date, _) {
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
                                                    : _isWeekend(date,
                                                            s.holidays.keys)
                                                        ? TextStyle(
                                                            color: Colors.red)
                                                        : null),
                                          );
                                        },
                                        markersBuilder:
                                            (context, date, events, holidays) {
                                          final children = <Widget>[];

                                          if (events.isNotEmpty) {
                                            children.add(
                                              Positioned(
                                                right: 1,
                                                bottom: 1,
                                                child: _buildEventsMarker(
                                                    date, events),
                                              ),
                                            );
                                          }

                                          return children;
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
                                    initialSelectedDay:
                                        addMonths(DateTime.now(), index),
                                    calendarController:
                                        s.calendarControllerList[index],
                                    events: s.events,
                                    holidays: s.holidays,
                                    availableGestures: AvailableGestures.none,
                                    calendarStyle: CalendarStyle(
                                      outsideDaysVisible: false,
                                    ),
                                    headerStyle: HeaderStyle(
                                        centerHeaderTitle: true,
                                        formatButtonVisible: false,
                                        leftChevronVisible: false,
                                        rightChevronVisible: false),
                                    builders: CalendarBuilders(
                                      selectedDayBuilder: (context, date, _) {
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
                                      markersBuilder:
                                          (context, date, events, holidays) {
                                        final children = <Widget>[];
                                        if (events.isNotEmpty) {
                                          children.add(
                                            Positioned(
                                              right: 1,
                                              bottom: 1,
                                              child: _buildEventsMarker(
                                                  date, events),
                                            ),
                                          );
                                        }

                                        return children;
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
}

// 참고
// https://velog.io/@adbr/flutter-tablecalendar-builders-example

// https://stackoverflow.com/questions/64976106/how-to-set-the-locale-property-to-tablecalendar-widget
