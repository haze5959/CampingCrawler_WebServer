import 'package:get/get.dart';
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
      showOneBtnAlert(res.msg, "확인", () {
        Get.back();
      });
      return;
    } else if (data == null) {
      showOneBtnAlert("서버가 불안정 합니다. 잠시 후 다시 시도해주세요.", "확인", () {
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
      showOneBtnAlert("서버가 불안정 합니다. 잠시 후 다시 시도해주세요.", "확인", () {
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

    final areaBit = editedArea
        .map((element) => element.toBit())
        .reduce((value, element) => value + element);

    final token = await Constants.user.value.firebaseUser?.getIdToken() ?? "";
    final res = await ApiRepo.user.putUserArea(token, areaBit);
    if (!res.result) {
      showOneBtnAlert(res.msg, "확인", () {});
      return;
    }

    Constants.user.value.info.favoriteAreaList = editedArea;
    isLoading.value = false;
  }

  void updatePushSetting() async {
    isLoading.value = true;
    final info = pushInfo.value;
    if (info == null) {
      showOneBtnAlert("설정 정보를 가져올 수 없습니다.", "확인", () {
        Get.back();
      });
      return;
    }

    final token = await Constants.user.value.firebaseUser?.getIdToken() ?? "";
    final res = await ApiRepo.user.putPushInfo(token, info);
    if (!res.result) {
      showOneBtnAlert(res.msg, "확인", () {});
      return;
    }

    isLoading.value = false;
  }
}
