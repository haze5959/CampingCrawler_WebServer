import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Controller
import 'package:good_place_camp/Controller/CampDetailContoller.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class CampDetailPage extends StatelessWidget {
  final String siteName;

  CampDetailPage({this.siteName});

  @override
  Widget build(BuildContext context) {
    final CampDetailContoller c = CampDetailContoller(siteName: siteName);

    final infoJson = Constants.campInfo[siteName];

    return Scaffold(
      appBar: AppBar(
        title: Text(infoJson.name),
        actions: [
          Obx(() => IconButton(
                icon: c.isFavorite.value
                    ? Icon(Icons.star, color: Colors.yellow)
                    : Icon(Icons.star_border_outlined, color: Colors.white),
                onPressed: () {
                  // Navigator.pop(context);
                  // 즐겨찾기 로직 필요
                },
              )),
        ],
      ),
      body: Obx(() => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (c.siteInfo != null)
                  _buildContent(context, c.siteInfo.value),
                ElevatedButton(
                  child: Text("홈페이지"),
                  onPressed: () {
                    c.launchHomepageURL();
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: Text("예약 사이트"),
                  onPressed: () {
                    c.launchReservationURL();
                  },
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildContent(BuildContext context, SiteInfo siteInfo) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.headline5.copyWith(color: Colors.white);
    final descriptionStyle = theme.textTheme.subtitle1;
    final addrStyle = theme.textTheme.caption;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              Positioned.fill(
                child: Ink.image(
                  image: AssetImage('assets/${siteInfo.site}.jpg'),
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
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "${Constants.campInfo[siteInfo.site].name}",
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
                    "예약정보 수집 시간 - ${siteInfo.updatedDate}",
                    style: addrStyle,
                  ),
                ),
                Text("${Constants.campInfo[siteInfo.site].desc}", maxLines: 2),
                Text("${Constants.campInfo[siteInfo.site].addr}",
                    style: addrStyle)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
