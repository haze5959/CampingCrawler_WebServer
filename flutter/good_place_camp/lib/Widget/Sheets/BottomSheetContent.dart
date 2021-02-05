import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetContent extends StatelessWidget {
  final DateTime date;
  final List<String> events;

  final isFullScreen = false.obs;

  BottomSheetContent({this.date, this.events});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          height:
              isFullScreen.value ? context.height : 300,
          child: Column(
            children: [Row(
              children: [
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
                      title: Text(events[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
