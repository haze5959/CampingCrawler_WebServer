import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SimpleCampCardItem extends StatelessWidget {
  final String siteName;

  SimpleCampCardItem({
    required this.siteName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: CARD_WIDTH,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Get.toNamed("/camp/detail/$siteName");
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
    final titleStyle = textTheme.subtitle1!.copyWith(color: Colors.white);
    final descriptionStyle = textTheme.bodyText2!;
    final addrStyle = textTheme.caption;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 184,
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: "$IMAGE_URL/$siteName.jpg",
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
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    Constants.campInfoMap[siteName]?.name ?? "_",
                    style: titleStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(CARD_MARGIN, CARD_MARGIN, CARD_MARGIN, 0),
        child: DefaultTextStyle(
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: descriptionStyle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Constants.campInfoMap[siteName]?.addr ?? "",
                  style: addrStyle)
            ],
          ),
        ),
      ),
    ]);
  }
}
