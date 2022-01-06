import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Widget/Common/CommonAppBar.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(pageName: "app_title".tr),
        body: Center(
              child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _buildContent()),
            ));
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("server_error_page_msg".tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
      ],
    );
  }
}
