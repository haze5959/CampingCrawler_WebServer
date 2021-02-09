import 'dart:js';

import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetContent extends StatelessWidget {
  final DateTime date;
  final List<String> events;

  final isFullScreen = false.obs;

  BottomSheetContent({this.date, this.events});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isFullScreen.value ? context.height : 300,
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
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: _buildListCell(context, events[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildListCell(BuildContext context, String title) {
    return TappableCampItem();
  }

  double listCellHeight(BuildContext context) {
    var height = context.mediaQuerySize.width / 2;
    const double maxHeight = 200;
    if(height > maxHeight) {
      height = maxHeight;
    }
    return height;
  }
}

class TappableCampItem extends StatelessWidget {
  // This height will allow for all the Card's content to fit comfortably within the card.
  static const height = 298.0;

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
                // This ensures that the Card's children (including the ink splash) are clipped correctly.
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    print('Card was tapped');
                  },
                  // Generally, material cards use onSurface with 12% opacity for the pressed state.
                  splashColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                  // Generally, material cards do not have a highlight overlay.
                  highlightColor: Colors.transparent,
                  child: TravelDestinationContent(),
                ),
              ),
            ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  SectionTitle({
    this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: Theme.of(context).textTheme.subtitle1),
      ),
    );
  }
}

class TravelDestinationContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.headline5.copyWith(color: Colors.white);
    final descriptionStyle = theme.textTheme.subtitle1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 184,
          child: Stack(
            children: [
              Positioned.fill(
                // In order to have the ink splash appear above the image, you
                // must use Ink.image. This allows the image to be painted as
                // part of the Material and display ink effects above it. Using
                // a standard Image will obscure the ink splash.
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
                  child: Text(
                    "destination.title",
                    style: titleStyle,
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
                  child: Text(
                    "destination.description",
                    style: descriptionStyle.copyWith(color: Colors.black54),
                  ),
                ),
                Text("destination.city)"),
                Text("destination.location")
              ],
            ),
          ),
        ),
      ],
    );
  }
}
