import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';

// Model
import 'package:good_place_camp/Model/PushInfo.dart';
import 'package:good_place_camp/Model/CampArea.dart';

class PushContoller extends GetxController {
  PushInfo pushInfo = PushInfo(
      usePushOnArea: false,
      useOnlyHolidayOnArea: false,
      useOnlyInMonthOnArea: false,
      usePushOnSite: false,
      useOnlyHolidayOnSite: false,
      useOnlyInMonthOnSite: false,
      reservationDayPush: false);

  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();

    reload();
  }

  void reload() async {
    isLoading.value = true;
    final token = await Constants.user.value.getToken() ?? "";
    final res = await ApiRepo.user.getUserPushInfo(token);
    if (!res.result) {
      showServerErrorAlert(res.msg, true);
      return;
    }

    final data = res.data!;
    pushInfo = data;
    isLoading.value = false;
    update();
  }

  void editArea(CampArea area) async {
    isLoading.value = true;
    final areaBit = Constants.user.value.info?.areaBit;

    if (areaBit == null) {
      showOneBtnAlert("server_error".tr, "confirm".tr, () {
        Get.back();
      });
      return;
    }

    final editedArea = fromBit(areaBit);

    if (editedArea.contains(area)) {
      editedArea.remove(area);
    } else {
      editedArea.add(area);
    }

    final editedAreaBit = toAreaBit(editedArea);
    final token = await Constants.user.value.getToken() ?? "";
    final res = await ApiRepo.user.putUserArea(token, editedAreaBit);
    if (!res.result) {
      showServerErrorAlert(res.msg, false);
      return;
    }

    Constants.user.value.info?.areaBit = editedAreaBit;
    isLoading.value = false;
  }

  void updatePushSetting() async {
    isLoading.value = true;
    final info = pushInfo;
    final token = await Constants.user.value.getToken() ?? "";
    final res = await ApiRepo.user.putPushInfo(token, info);
    if (!res.result) {
      showServerErrorAlert(res.msg, false);
      return;
    }

    isLoading.value = false;
    update();
  }
}
