import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget obxLoadingWidget(RxBool isLoading) {
  return Obx(() => isLoading.value
      ? Center(
          child: Container(
              width: 150,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              ),
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(color: Colors.lightGreen)))
      : Container(width: 0, height: 0));
}
