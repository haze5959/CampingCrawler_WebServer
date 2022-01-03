import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonAppBar extends AppBar {
  final String pageName;
  final Color? backgroundColor;
  final List<Widget>? actions;

  CommonAppBar({required this.pageName, this.backgroundColor, this.actions})
      : super(
            leading: Row(
              children: [
                if (Navigator.canPop(Get.context!))
                  const BackButton(),
                const SizedBox(width: 10),
                IconButton(
                    onPressed: () {
                      Get.toNamed("/");
                    },
                    icon: const Icon(Icons.home))
              ],
            ),
            leadingWidth: 100,
            title:
                Text(pageName, style: TextStyle(fontWeight: FontWeight.bold)),
            actions: actions);
}
