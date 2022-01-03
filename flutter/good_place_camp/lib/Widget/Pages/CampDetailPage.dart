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
                          _buildButtons(c),
                          _buildReservationContent(c),
                          const SizedBox(height: 3),
                          CalenderWidget(controller: c, isOneCampSite: true),
                          if (!GetPlatform.isWeb) ...[
                            _titleDivider("camp_detail_map_title".tr),
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
                            const SizedBox(height: 20),
                          ],
                          _titleDivider(""),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightGreen),
                            label: Text("dialog_edit_request"
                                .trParams({"id": infoJson.name})),
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showCampEditRequestAlert("${infoJson.name}");
                            },
                          ),
                          const SizedBox(height: 40),
                          FooterWidget()
                        ],
                      )),
            ));
  }

  Widget _buildInfoContent(CampDetailContoller c) {
    final textTheme = Get.theme.textTheme;
    final titleStyle = textTheme.headline5!.copyWith(color: Colors.white);
    final descriptionStyle = textTheme.subtitle1!;
    final textStyle = const TextStyle(color: Colors.grey, fontSize: 14);

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
            _titleDivider("camp_detail_info_title".tr),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: DefaultTextStyle(
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: descriptionStyle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${c.campInfo!.desc}", maxLines: 2, style: textStyle),
                    const SizedBox(height: 5),
                    TextButton.icon(
                        icon: const Icon(Icons.location_on,
                            size: 14, color: Colors.grey),
                        style: TextButton.styleFrom(
                            minimumSize: Size(50, 20),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        onPressed: () {
                          c.launchMap();
                        },
                        label: Text("${c.campInfo!.addr}", style: textStyle)),
                    const SizedBox(height: 5),
                    TextButton.icon(
                        icon: const Icon(Icons.call,
                            size: 14, color: Colors.grey),
                        style: TextButton.styleFrom(
                            minimumSize: Size(50, 20),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        onPressed: () {
                          c.callPhoneNum();
                        },
                        label: Text("${c.campInfo!.phone}", style: textStyle))
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildButtons(CampDetailContoller c) {
    return Container(
        constraints: const BoxConstraints(maxWidth: MAX_WIDTH),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          _titleDivider("camp_detail_link_title".tr),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.lightGreen),
                icon: const Icon(Icons.home, size: 18),
                label: Text("homepage".tr),
                onPressed: () {
                  c.launchHomepageURL();
                },
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.lightGreen),
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text("reservation_site".tr),
                onPressed: () {
                  c.launchReservationURL();
                },
              ),
            ],
          )
        ]));
  }

  Widget _buildReservationContent(CampDetailContoller c) {
    final textStyle = const TextStyle(color: Colors.grey, fontSize: 14);

    return Container(
      constraints: const BoxConstraints(maxWidth: MAX_WIDTH),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _titleDivider("camp_detail_reservation_title".tr),
          Tooltip(
              message: "camp_reservation_open_tooltip".tr,
              child: Text(
                  "camp_reservation_open".tr +
                      " - ${getReservationOpenStr(c.campInfo!.reservationOpen)}",
                  style: textStyle)),
          const SizedBox(height: 3),
          Tooltip(
            message: "camp_collect_time_tooltip".tr,
            child: Text(
              "camp_collect_time".tr +
                  " - ${remainTime(c.siteInfo!.updatedDate)}",
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleDivider(String title) {
    final titleStyle = const TextStyle(
        color: Colors.lightGreen, fontSize: 18, fontWeight: FontWeight.bold);

    return Container(
        constraints: const BoxConstraints(maxWidth: MAX_WIDTH),
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(title, style: titleStyle)),
          Divider(
            thickness: 1,
          )
        ]));
  }
}
