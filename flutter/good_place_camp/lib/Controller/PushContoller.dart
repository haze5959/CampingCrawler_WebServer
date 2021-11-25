import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';

// Model
import 'package:good_place_camp/Model/PushInfo.dart';
import 'package:good_place_camp/Model/CampArea.dart';

class PushContoller extends GetxController {
  Rx<PushInfo> pushInfo = PushInfo(
          usePushOnArea: false,
          useOnlyHolidayOnArea: false,
          useOnlyInMonthOnArea: false,
          usePushOnSite: false,
          useOnlyHolidayOnSite: false,
          useOnlyInMonthOnSite: false,
          reservationDayPush: false)
      .obs;

  RxBool isLoading = false.obs;

  @override
  void onReady() async {
    super.onReady();

    reload();
  }

  void reload() async {
    isLoading.value = true;
    final token = await Constants.user.value.firebaseUser?.getIdToken() ?? "";
    final res = await ApiRepo.user.getUserPushInfo(token);
    final data = res.data;
    if (!res.result) {
      showOneBtnAlert(res.msg, "confirm".tr(), () {
        Get.back();
      });
      return;
    } else if (data == null) {
      showOneBtnAlert("server_error".tr(args: [res.msg]), "confirm".tr(), () {
        Get.back();
      });
      return;
    }

    pushInfo.value = data;

    isLoading.value = false;
  }

  void editArea(CampArea area) async {
    isLoading.value = true;
    final editedArea = Constants.user.value.info.favoriteAreaList;

    if (editedArea == null) {
      showOneBtnAlert("server_error".tr(args: ["no_favorte_area"]), "confirm".tr(), () {
        Get.back();
      });
      return;
    }

    if (area == CampArea.all) {
      editedArea.clear();
    } else {
      if (editedArea.contains(area)) {
        editedArea.remove(area);
      } else {
        editedArea.add(area);
      }
    }

    final areaBit = toAreaBit(editedArea);
    final token = await Constants.user.value.firebaseUser?.getIdToken() ?? "";
    final res = await ApiRepo.user.putUserArea(token, areaBit);
    if (!res.result) {
      showOneBtnAlert(res.msg, "confirm".tr(), () {});
      return;
    }

    Constants.user.value.info.favoriteAreaList = editedArea;
    isLoading.value = false;
  }

  void updatePushSetting() async {
    isLoading.value = true;
    final info = pushInfo.value;
    final token = await Constants.user.value.firebaseUser?.getIdToken() ?? "";
    final res = await ApiRepo.user.putPushInfo(token, info);
    if (!res.result) {
      showOneBtnAlert(res.msg, "confirm".tr(), () {});
      return;
    }

    isLoading.value = false;
  }
}
