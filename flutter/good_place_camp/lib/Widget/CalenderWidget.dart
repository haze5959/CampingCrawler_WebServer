import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class CalenderWidget extends StatelessWidget {
  @override
  Widget build(context) {
    return GetBuilder<HomeController>(
        builder: (s) => Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(maxWidth: CALENDER_WIDTH),
            child: Column(
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
                            markersBuilder: (context, date, events, holidays) {
                              final children = <Widget>[];

                              if (events.isNotEmpty) {
                                children.add(
                                  Positioned(
                                    right: 1,
                                    bottom: 1,
                                    child: _buildEventsMarker(
                                        s.calendarControllerList[index],
                                        date,
                                        events),
                                  ),
                                );
                              }

                              return children;
                            },
                          ),
                          onDaySelected: s.onDaySelected,
                          rowHeight: CALENDER_WIDTH / 8,
                        ))
                    .toList())));
  }

  Widget _buildEventsMarker(CalendarController c, DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: c.isSelected(date) ? Colors.brown[500] : Colors.blue[400],
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

  Widget _buildSelectedDay(BuildContext context, DateTime date, List events) {
    return null;
  }
}

// 참고
// https://velog.io/@adbr/flutter-tablecalendar-builders-example

// https://stackoverflow.com/questions/64976106/how-to-set-the-locale-property-to-tablecalendar-widget
