import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class PromotionCardItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Get.toNamed("/board/write");
        },
        splashColor: Get.theme.colorScheme.onSurface.withOpacity(0.12),
        highlightColor: Colors.transparent,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              Positioned.fill(
                child: Ink.image(
                  image: const AssetImage('assets/Camp_Default.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    padding: const EdgeInsets.all(5.0),
                    child: const Text("promotion_msg_1",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20))
                        .tr(),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Description and share/explore buttons.
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("promotion_msg_2",
                      maxLines: 2,
                      style: const TextStyle(color: Colors.black, fontSize: 14))
                  .tr()
            ],
          ),
        ),
      ],
    );
  }
}
