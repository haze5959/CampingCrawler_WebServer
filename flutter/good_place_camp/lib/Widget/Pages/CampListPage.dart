import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Widgets
import 'package:good_place_camp/Widget/GPCAppBar.dart';

// Cards
import 'package:good_place_camp/Widget/Cards/TappableCampCardItem.dart';
import 'package:good_place_camp/Widget/Cards/SimpleCampCardItem.dart';
import 'package:good_place_camp/Widget/Cards/PromotionCardItem.dart';

// Controller
import 'package:good_place_camp/Controller/HomeContoller.dart';

class CampListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isFavoritePage =
        Get.parameters['is_favorite'] == 'true' ? true : false;

    return Scaffold(
      appBar: isFavoritePage
          ? GPCAppBar(pageName: "camp_my".tr, showFilter: false)
          : GPCAppBar(pageName: "camp".tr, showFilter: true),
      body: Center(
        child: Container(
            constraints: const BoxConstraints(maxWidth: MAX_WIDTH),
            child: Scrollbar(
                child:
                    isFavoritePage ? _buildFavoriteList() : _buildCampList())),
      ),
    );
  }

  Widget _buildCampList() {
    Get.put(HomeController());

    return GetBuilder<HomeController>(
        builder: (c) => c.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: c.siteInfoList.length + 1,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 15,
                  );
                },
                itemBuilder: (context, index) {
                  if (index < c.siteInfoList.length) {
                    return TappableCampCardItem(
                        siteInfo: c.siteInfoList[index]);
                  } else {
                    return PromotionCardItem();
                  }
                },
              ));
  }

  Widget _buildFavoriteList() {
    return Obx(() => ListView.separated(
          itemCount: Constants.user.value.info.favoriteList?.length ?? 0 + 1,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 15,
            );
          },
          itemBuilder: (context, index) {
            if (index < (Constants.user.value.info.favoriteList?.length ?? 0)) {
              return SimpleCampCardItem(
                  siteName: Constants.user.value.info.favoriteList![index]);
            } else {
              return PromotionCardItem();
            }
          },
        ));
  }
}
