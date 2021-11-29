import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

Widget obxLoadingWidget(RxBool isLoading) {
  return Obx(() => isLoading.value
      ? Center(child: CircularProgressIndicator())
      : Container(width: 0, height: 0));
}
