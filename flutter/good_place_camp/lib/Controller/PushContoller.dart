import 'package:get/get.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Repository
import 'package:good_place_camp/Repository/PushRepository.dart';

class PushContoller extends GetxController {
  final int userId;

  PushContoller({this.userId}) {
    reload();
  }

  PushRepository repo = PushRepository();

  RxBool isLoading = true.obs;

  void reload() async {
    isLoading.value = true;
    final result = await repo.getPushInfoWith(userId);
    if (result.hasError) {
      showOneBtnAlert(Get.context, result.statusText, "재시도", reload);
      return;
    } else if (!result.body.result) {
      showOneBtnAlert(Get.context, result.body.msg, "재시도", reload);
      return;
    }

    isLoading.value = false;
  }
}
