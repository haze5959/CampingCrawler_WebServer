import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class CalenderWidget extends StatelessWidget {
  final bool isVertical;

  CalenderWidget({this.isVertical});

  @override
  Widget build(context) {
    return GetBuilder<HomeController>(
        builder: (s) => Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            constraints:
                isVertical ? BoxConstraints(maxWidth: CALENDER_WIDTH) : BoxConstraints(maxWidth: MAX_WIDTH + CALENDER_WIDTH),
            child: isVertical
                ? _buildVerticalCalendar(s, context)
                : _buildHorizenCalendar(s, context)));
  }

  Widget _buildHorizenCalendar(HomeController s, BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [0, 1, 2]
            .map((index) => ClipRect(child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.5)),
                      child: Container(
                          width: CALENDER_WIDTH,
                          child: TableCalendar(
                            locale:
                                Localizations.localeOf(context).languageCode,
                            initialSelectedDay: Jiffy().add(months: index),
                            calendarController: s.calendarControllerList[index],
                            events: s.events,
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
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: s.selectedDay.month ==
                                              s.calendarControllerList[index]
                                                  .focusedDay.month
                                          ? Colors.blueAccent
                                          : isToday(date)
                                              ? const Color(0xFF9FA8DA)
                                              : null),
                                  margin: const EdgeInsets.all(6.0),
                                  alignment: Alignment.center,
                                  child: Text('${date.day}',
                                      style: isToday(date)
                                          ? TextStyle().copyWith(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            )
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
                                      child: _buildEventsMarker(date, events),
                                    ),
                                  );
                                }

                                return children;
                              },
                            ),
                            onDaySelected: s.onDaySelected,
                            rowHeight: CALENDER_WIDTH / 6,
                          ))),
                )))
            .toList());
  }

  Widget _buildVerticalCalendar(HomeController s, BuildContext context) {
    return Column(
        children: [0, 1, 2]
            .map((index) => TableCalendar(
                  locale: Localizations.localeOf(context).languageCode,
                  initialSelectedDay: Jiffy().add(months: index),
                  calendarController: s.calendarControllerList[index],
                  events: s.events,
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
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: s.selectedDay.month ==
                                    s.calendarControllerList[index].focusedDay
                                        .month
                                ? Colors.blueAccent
                                : isToday(date)
                                    ? const Color(0xFF9FA8DA)
                                    : null),
                        margin: const EdgeInsets.all(6.0),
                        alignment: Alignment.center,
                        child: Text('${date.day}',
                            style: isToday(date)
                                ? TextStyle().copyWith(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  )
                                : null),
                      );
                    },
                    markersBuilder: (context, date, events, holidays) {
                      final children = <Widget>[];

                      if (events.isNotEmpty) {
                        children.add(
                          Positioned(
                            right: 1,
                            bottom: 1,
                            child: _buildEventsMarker(date, events),
                          ),
                        );
                      }

                      return children;
                    },
                  ),
                  onDaySelected: s.onDaySelected,
                  rowHeight: CALENDER_WIDTH / 6,
                ))
            .toList());
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  bool isToday(DateTime date) {
    final today = DateTime.now();
    if (date.month == today.month && date.day == today.day) {
      return true;
    } else {
      return false;
    }
  }
}

// 참고
// https://velog.io/@adbr/flutter-tablecalendar-builders-example

// https://stackoverflow.com/questions/64976106/how-to-set-the-locale-property-to-tablecalendar-widget
