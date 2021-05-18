import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Model
import 'package:good_place_camp/Model/PushInfo.dart';

// Repository
import 'package:good_place_camp/Repository/UserRepository.dart';

class PushContoller extends GetxController {
  final UserRepository repo = UserRepository();

  Rx<PushInfo> pushInfo =
      PushInfo([], false, false, false, [], false, false, false, false).obs;
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

  void delete(args) {
    
  }
}
