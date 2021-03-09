import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

class PushSettingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PushSettingPage"),
        actions: [
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: Text("PushSettingPage"),
              onPressed: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}
