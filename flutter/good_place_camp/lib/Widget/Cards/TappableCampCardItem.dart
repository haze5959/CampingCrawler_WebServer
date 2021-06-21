import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:good_place_camp/Utils/DateUtils.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/CampDetailPage.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class TappableCampCardItem extends StatelessWidget {
  final SiteInfo siteInfo;

  TappableCampCardItem({
    this.siteInfo,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.push<void>(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        CampDetailPage(siteName: siteInfo.site),
                  ),
                );
              },
              splashColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
              highlightColor: Colors.transparent,
              child: _buildContent(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
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
                child: CachedNetworkImage(
                  imageUrl: "$IMAGE_URL/${siteInfo.site}.jpg",
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/Camp_Default.png'),
                  fit: BoxFit.cover,
                  fadeInCurve: Curves.easeIn,
                  fadeInDuration: Duration(seconds: 2),
                  fadeOutCurve: Curves.easeOut,
                  fadeOutDuration: Duration(seconds: 2),
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
                    "예약정보 수집 시간 - ${remainTime(siteInfo.updatedDate)}",
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
