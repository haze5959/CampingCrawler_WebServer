import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget obxLoadingWidget(RxBool isLoading) {
  return Obx(() => isLoading.value
      ? const Center(child: CircularProgressIndicator())
      : Container(width: 0, height: 0));
}
