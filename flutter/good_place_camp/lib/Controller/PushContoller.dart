import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Model
import 'package:good_place_camp/Model/PushInfo.dart';

// Repository
import 'package:good_place_camp/Repository/UserRepository.dart';

class PushContoller extends GetxController {
  final UserRepository repo = UserRepository();

  Rx<PushInfo> pushInfo =
      PushInfo(false, false, false, false, false, false, false).obs;
  RxBool isLoading = false.obs;

  @override
  void onReady() async {
    super.onReady();
  }

  void reload() async {
    isLoading.value = true;
    final token = await Constants.user.value.firebaseUser.getIdToken();
    final result = await repo.getUserPushInfo(token);
    if (result.hasError) {
      showOneBtnAlert(Get.context, result.statusText, "뒤로가기", Get.back);
      return;
    } else if (!result.body.result) {
      showOneBtnAlert(Get.context, result.body.msg, "뒤로가기", Get.back);
      return;
    }

    pushInfo.value = PushInfo.fromJson(result.body.data);

    isLoading.value = false;
  }

  void editArea(CampArea area) async {
    isLoading.value = true;
    var editedArea = pushInfo.value.favoriteArea;

    switch (area) {
      case CampArea.all:
        editedArea.clear();
        break;
      default:
        if (editedArea.contains(area)) {
          editedArea.remove(area);
        } else {
          editedArea.add(area);
        }
        break;
    }

    final areaBit = editedArea
        .map((element) => element.toBit())
        .reduce((value, element) => value + element);

    final token = await Constants.user.value.firebaseUser.getIdToken();
    final result = await repo.postUserArea(token, areaBit);
    isLoading.value = false;

    if (result.hasError) {
      showOneBtnAlert(Get.context, result.statusText, "확인", () {});
      return;
    } else if (!result.body.result) {
      showOneBtnAlert(Get.context, result.body.msg, "확인", () {});
      return;
    }

    pushInfo.value.favoriteArea = editedArea;
  }

  void updatePushSetting() async {
    isLoading.value = true;

    final token = await Constants.user.value.firebaseUser.getIdToken();
    final result = await repo.putPushInfo(token, pushInfo.value);
    isLoading.value = false;

    if (result.hasError) {
      showOneBtnAlert(Get.context, result.statusText, "확인", () {});
      return;
    } else if (!result.body.result) {
      showOneBtnAlert(Get.context, result.body.msg, "확인", () {});
      return;
    }
  }
}
