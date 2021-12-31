import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_place_camp/Widget/CommonAppBar.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Utils/DateUtils.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Controller
import 'package:good_place_camp/Controller/CampDetailContoller.dart';

// Widgets
import 'package:good_place_camp/Widget/FooterWidget.dart';
import 'package:good_place_camp/Widget/CalenderWidget.dart';

class CampDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String siteName = Get.parameters['id'] ?? "";
    final infoJson = Constants.campInfoMap[siteName]!;

    return GetBuilder<CampDetailContoller>(
        init: CampDetailContoller(siteName: siteName),
        global: false,
        builder: (c) => Scaffold(
              appBar: CommonAppBar(
                pageName: infoJson.name,
                backgroundColor: Colors.lightGreen.shade400,
                actions: [
                  IconButton(
                    tooltip: "favorite".tr,
                    icon: Obx(() => c.isFavorite.value
                        ? Icon(Icons.star, color: Colors.yellow)
                        : Icon(Icons.star_border_outlined,
                            color: Colors.white)),
                    onPressed: c.onClickFavorite,
                  ),
                ],
              ),
              body: c.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildInfoContent(c),
                          const SizedBox(height: 10),
                          _buildButtons(c),
                          const SizedBox(height: 20),
                          CalenderWidget(controller: c, isOneCampSite: true),
                          _buildSelectedInfo(c),
                          const SizedBox(height: 20),
                          if (!GetPlatform.isWeb)
                            SizedBox(
                                height: CALENDER_WIDTH,
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  myLocationButtonEnabled: false,
                                  rotateGesturesEnabled: false,
                                  scrollGesturesEnabled: false,
                                  zoomControlsEnabled: false,
                                  zoomGesturesEnabled: false,
                                  tiltGesturesEnabled: false,
                                  onTap: (position) {
                                    c.launchMap();
                                  },
                                  markers: {
                                    Marker(
                                      markerId: MarkerId(""),
                                      position: LatLng(
                                          c.campInfo!.lat, c.campInfo!.lon),
                                      infoWindow:
                                          InfoWindow(title: infoJson.name),
                                    )
                                  },
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        c.campInfo!.lat, c.campInfo!.lon),
                                    zoom: 14.0,
                                  ),
                                )),
                          TextButton.icon(
                            label: Text(infoJson.name + "dialog_report_msg".tr),
                            icon: Icon(Icons.report_gmailerrorred_outlined),
                            onPressed: () {
                              showReportAlert("${infoJson.key}", "camp".tr);
                            },
                          ),
                          FooterWidget()
                        ],
                      )),
            ));
  }

  Widget _buildInfoContent(CampDetailContoller c) {
    final textTheme = Get.theme.textTheme;
    final titleStyle = textTheme.headline5!.copyWith(color: Colors.white);
    final descriptionStyle = textTheme.subtitle1!;
    final addrStyle = textTheme.caption;

    return Container(
        constraints: const BoxConstraints(maxWidth: MAX_WIDTH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: "$IMAGE_URL/${c.siteInfo!.site}.jpg",
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/Camp_Default.png'),
                      fit: BoxFit.cover,
                      fadeInCurve: Curves.easeIn,
                      fadeInDuration: const Duration(seconds: 2),
                      fadeOutCurve: Curves.easeOut,
                      fadeOutDuration: const Duration(seconds: 2),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "${c.campInfo!.name}",
                          style: titleStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Description and share/explore buttons.
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: DefaultTextStyle(
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: descriptionStyle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: "camp_info_1".tr,
                      child: Text(
                        "camp_collect_time".tr +
                            " - ${remainTime(c.siteInfo!.updatedDate)}",
                        style: addrStyle,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Tooltip(
                        message: "camp_info_2".tr,
                        child: Text(
                          "camp_reservation_open".tr +
                              " - ${getReservationOpenStr(c.campInfo!.reservationOpen)}",
                          style: addrStyle,
                        )),
                    const SizedBox(height: 3),
                    Text("${c.campInfo!.desc}", maxLines: 2),
                    const SizedBox(height: 3),
                    TextButton.icon(
                        icon: const Icon(Icons.location_on, size: 20),
                        style: TextButton.styleFrom(
                            minimumSize: Size(50, 20),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        onPressed: () {
                          c.launchMap();
                        },
                        label: Text("${c.campInfo!.addr}", style: addrStyle)),
                    TextButton.icon(
                        icon: const Icon(Icons.call, size: 20),
                        style: TextButton.styleFrom(
                            minimumSize: Size(50, 20),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        onPressed: () {
                          c.callPhoneNum();
                        },
                        label: Text("${c.campInfo!.phone}", style: addrStyle))
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildButtons(CampDetailContoller c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
          icon: const Icon(Icons.home, size: 18),
          label: Text("homepage".tr),
          onPressed: () {
            c.launchHomepageURL();
          },
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
          icon: const Icon(Icons.calendar_today, size: 18),
          label: Text("reservation_site".tr),
          onPressed: () {
            c.launchReservationURL();
          },
        ),
      ],
    );
  }

  Widget _buildSelectedInfo(CampDetailContoller c) {
    return Obx(() => Container(
        width: CALENDER_WIDTH, child: Text(c.selectedSiteInfo.value)));
  }
}
