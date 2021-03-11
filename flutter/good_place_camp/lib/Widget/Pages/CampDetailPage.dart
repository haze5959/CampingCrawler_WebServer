import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:table_calendar/table_calendar.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/CampDetailContoller.dart';

// Widgets
import 'package:good_place_camp/Widget/FooterWidget.dart';

class CampDetailPage extends StatelessWidget {
  final String siteName;

  CampDetailPage({this.siteName});

  @override
  Widget build(BuildContext context) {
    final CampDetailContoller c = CampDetailContoller(siteName: siteName);
    final infoJson = Constants.campInfo[siteName];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade400,
        title:
            Text(infoJson.name, style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: "즐겨찾기",
            icon: Obx(() => c.isFavorite.value
                ? Icon(Icons.star, color: Colors.yellow)
                : Icon(Icons.star_border_outlined, color: Colors.white)),
            onPressed: c.onClickFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoContent(context, c),
              SizedBox(height: 20),
              _buildButtons(c),
              SizedBox(height: 50),
              _buildCalender(context, c),
              SizedBox(height: 50),
              FooterWidget()
            ],
          )),
    );
  }

  Widget _buildInfoContent(BuildContext context, CampDetailContoller c) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.headline5.copyWith(color: Colors.white);
    final descriptionStyle = theme.textTheme.subtitle1;
    final addrStyle = theme.textTheme.caption;

    return Obx(
      () => c.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Ink.image(
                        image: AssetImage('assets/${c.siteInfo.site}.jpg'),
                        fit: BoxFit.cover,
                        child: Container(),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "${Constants.campInfo[c.siteInfo.site].name}",
                            style: titleStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Description and share/explore buttons.
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: DefaultTextStyle(
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: descriptionStyle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Tooltip(
                        message: "예약정보 수집은 원활한 예약 트래픽을 위하여 1시간에 한번 수집됩니다.",
                        child: Text(
                          "예약정보 수집 시간 - ${c.siteInfo.updatedDate}",
                          style: addrStyle,
                        ),
                      ),
                      Text("${Constants.campInfo[c.siteInfo.site].desc}",
                          maxLines: 2),
                      Text("${Constants.campInfo[c.siteInfo.site].addr}",
                          style: addrStyle)
                    ],
                  ),
                ),
              ),
            ]),
    );
  }

  Widget _buildButtons(CampDetailContoller c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
          icon: const Icon(Icons.home, size: 18),
          label: Text("홈페이지"),
          onPressed: () {
            c.launchHomepageURL();
          },
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
          icon: const Icon(Icons.calendar_today, size: 18),
          label: Text("예약 사이트"),
          onPressed: () {
            c.launchReservationURL();
          },
        ),
      ],
    );
  }

  Widget _buildCalender(BuildContext context, CampDetailContoller c) {
    return Obx(() => c.isLoading.value
        ? Center(child: CircularProgressIndicator())
        : ClipRect(
            child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.5)),
                    child: Container(
                        width: CALENDER_WIDTH,
                        child: TableCalendar(
                          locale: Localizations.localeOf(context).languageCode,
                          calendarController: c.calendarController,
                          events: c.events,
                          availableGestures: AvailableGestures.horizontalSwipe,
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                          ),
                          headerStyle: HeaderStyle(
                              centerHeaderTitle: true,
                              formatButtonVisible: false),
                          builders: CalendarBuilders(
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
                          rowHeight: CALENDER_WIDTH / 6,
                        ))))));
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
        child: Icon(Icons.date_range_outlined, size: 12),
      ),
    );
  }
}
