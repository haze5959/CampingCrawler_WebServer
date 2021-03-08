import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/TappableCampCardItem.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class BottomSheetContent extends StatelessWidget {
  final DateTime date;
  final List<SiteInfo> infoList;

  final isFullScreen = false.obs;

  BottomSheetContent({this.date, this.infoList});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: isFullScreen.value ? context.height : context.height / 2 + 100,
        child: Scaffold(
            body: Column(
              children: [
                Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(children: [
                  Text(
                    "${DateFormat("yyyy-MM-dd").format(date)}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    "ℹ️ 예약정보 수집은 원활한 예약 트래픽을 위하여 1시간에 한번 수집됩니다.",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ])),
                const Divider(thickness: 1),
                Expanded(
                  child: Container(
                      constraints: BoxConstraints(maxWidth: MAX_WIDTH),
                      child: ListView.builder(
                        itemCount: infoList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: _buildListCell(context, infoList[index]),
                          );
                        },
                      )),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                elevation: 0.0,
                child: Icon(Icons.expand),
                backgroundColor: Colors.lightGreen.shade400,
                onPressed: () {
                  isFullScreen.toggle();
                }))));
  }

  Widget _buildListCell(BuildContext context, SiteInfo siteInfo) {
    return TappableCampCardItem(siteInfo: siteInfo);
  }
}
