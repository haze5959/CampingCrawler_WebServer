import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

abstract class ScrollContentSheet extends StatelessWidget {
  Widget contentsScrollWidget(ScrollController? controller);
}

abstract class GPCSheet extends ScrollContentSheet {
  final Rx<DateTime> currentDate;
  final Map<DateTime, List<String>> holidayList;

  GPCSheet(this.currentDate, this.holidayList);

  @override
  Widget build(BuildContext context) {
    if (Constants.isPhoneSize) {
      return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Obx(() {
              final prevDate = currentDate.value.add(Duration(days: -1));
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
                            onPressed: prevDate.isBefore(
                                    DateTime.now().add(Duration(days: -1)))
                                ? null
                                : () {
                                    currentDate.value = prevDate;
                                  },
                          ),
                          const Spacer(),
                          _buildSelectedWidget(currentDate.value),
                          const Spacer(),
                          OutlinedButton.icon(
                            icon: Text(
                              "${DateFormat("MM-dd (EEE)", 'ko_KR').format(currentDate.value.add(Duration(days: 1)))}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                            ),
                            label: const Icon(Icons.chevron_right_outlined,
                                size: 18),
                            onPressed: () {
                              currentDate.value =
                                  currentDate.value.add(Duration(days: 1));
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
                    child: contentsScrollWidget(scrollController),
                  )
                ],
              );
            });
          });
    } else {
      final isFullScreen = false.obs;

      return Obx(() {
        final prevDate = currentDate.value.add(Duration(days: -1));
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
                                      currentDate.value = prevDate;
                                    },
                            ),
                            const Spacer(),
                            _buildSelectedWidget(currentDate.value),
                            const Spacer(),
                            OutlinedButton.icon(
                              icon: Text(
                                "${DateFormat("MM-dd (EEE)", 'ko_KR').format(currentDate.value.add(Duration(days: 1)))}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              label: const Icon(Icons.chevron_right_outlined,
                                  size: 18),
                              onPressed: () {
                                currentDate.value =
                                    currentDate.value.add(Duration(days: 1));
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
                          child: contentsScrollWidget(null)),
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
    for (final key in holidayList.keys) {
      if (key.month == currentDate.month && key.day == currentDate.day) {
        final holidayName = holidayList[key]?[0] ?? "";
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
}
