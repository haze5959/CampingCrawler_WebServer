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
          height: isFullScreen.value ? context.height - 80 : context.height / 2,
          child: Column(
            children: [
              Row(children: [
                SizedBox(width: 50),
                Spacer(),
                Text(
                  "${DateFormat("yyyy-MM-dd").format(date)}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    isFullScreen.toggle();
                  },
                  child: Icon(
                    Icons.expand,
                    color: Colors.black,
                    size: 24,
                    semanticLabel: 'Expand',
                  ),
                )
              ]),
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
        ));
  }

  Widget _buildListCell(BuildContext context, SiteInfo siteInfo) {
    return TappableCampCardItem(siteInfo: siteInfo);
  }
}