import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Widgets
import 'package:good_place_camp/Widget/Pages/CampDetailPage.dart';

class SimpleCampCardItem extends StatelessWidget {
  final String siteName;

  SimpleCampCardItem({
    required this.siteName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: CARD_WIDTH,
        height: CARD_HEIGHT,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push<void>(
                context,
                CupertinoPageRoute(
                    builder: (context) => CampDetailPage(siteName)),
              );
            },
            splashColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
            highlightColor: Colors.transparent,
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.subtitle1!.copyWith(color: Colors.white);
    final descriptionStyle = theme.textTheme.bodyText2!;
    final addrStyle = theme.textTheme.caption;

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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
