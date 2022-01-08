import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:good_place_camp/Utils/DateUtils.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class TappableCampCardItem extends StatelessWidget {
  final SiteDateInfo siteInfo;

  TappableCampCardItem({
    required this.siteInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Get.toNamed("/camp/detail/${siteInfo.site}");
            },
            splashColor: Get.theme.colorScheme.onSurface.withOpacity(0.12),
            highlightColor: Colors.transparent,
            child: _buildContent(),
          ),
        ));
  }

  Widget _buildContent() {
    final textTheme = Get.theme.textTheme;
    final titleStyle = textTheme.headline5!.copyWith(color: Colors.white);
    final descriptionStyle = textTheme.subtitle1!;
    final addrStyle = textTheme.caption;

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
                  fadeInDuration: const Duration(seconds: 2),
                  fadeOutCurve: Curves.easeOut,
                  fadeOutDuration: const Duration(seconds: 2),
                ),
              ),
              Positioned(
                bottom: CARD_MARGIN,
                left: CARD_MARGIN,
                right: CARD_MARGIN,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      Constants.campInfoMap[siteInfo.site]?.name ?? "_",
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
                  message: "camp_collect_time_tooltip".tr,
                  child: Text(
                    "camp_collect_time".tr +
                        " - ${remainTime(siteInfo.updatedDate)}",
                    style: addrStyle,
                  ),
                ),
                Text(Constants.campInfoMap[siteInfo.site]?.addr ?? "_",
                    style: addrStyle)
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TappableReservationInfoCardItem extends StatelessWidget {
  final ReservationInfo info;

  TappableReservationInfoCardItem({
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Get.toNamed("/camp/detail/${info.site}");
          },
          splashColor: Get.theme.colorScheme.onSurface.withOpacity(0.12),
          highlightColor: Colors.transparent,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final textTheme = Get.theme.textTheme;
    final titleStyle = textTheme.headline5;
    final addrStyle = textTheme.caption;

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            Constants.campInfoMap[info.site]?.name ?? "_",
            style: titleStyle,
          ),
          Tooltip(
            message: "camp_reservation_open_tooltip".tr,
            child: Text(
              "camp_reservation_open".tr +
                  " - ${getReservationOpenStr(info.desc)}",
              style: addrStyle,
            ),
          )
        ]));
  }
}
