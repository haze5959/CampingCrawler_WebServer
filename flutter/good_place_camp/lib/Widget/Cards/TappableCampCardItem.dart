import 'package:flutter/material.dart';
import 'package:good_place_camp/Constants.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class TappableCampCardItem extends StatelessWidget {
  static const height = 298.0;

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
          height: height,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                print('Card was tapped');
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
          height: 184,
          child: Stack(
            children: [
              Positioned.fill(
                child: Ink.image(
                  image: AssetImage('assets/camp_munsoo.jpg'),
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
                      "${CAMP_INFO[siteInfo.site]["name"]}",
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: DefaultTextStyle(
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: descriptionStyle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // This array contains the three line description on each card
                // demo.
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Tooltip(
                      message: "예약정보 수집은 원활한 예약 트래픽을 위하여 1시간에 한번 수집됩니다.",
                      child: Text(
                        "예약정보 수집 시간 - ${siteInfo.updatedDate}",
                        style: addrStyle,
                      ),
                    )),
                Text("${CAMP_INFO[siteInfo.site]["desc"]}", maxLines: 2),
                Text("${CAMP_INFO[siteInfo.site]["addr"]}", style: addrStyle)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
