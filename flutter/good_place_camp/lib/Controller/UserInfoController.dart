import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Models
import 'package:good_place_camp/Model/CampUser.dart';

// Repository
import 'package:good_place_camp/Repository/UserRepository.dart';

class UserInfoController extends GetxController {
  UserInfoController() {
    // reload();
  }

  UserRepository repo = UserRepository();

  RxBool isLoading = true.obs;

  void reload() async {
    isLoading.value = true;
    await Constants.user.value.reloadInfo();

    isLoading.value = false;
  }

  void changeNick(String nick) async {
    isLoading.value = true;
    final idToken = await Constants.user.value.firebaseUser.getIdToken();
    final result = await repo.putUserNick(idToken, nick);
    if (result.hasError) {
      showOneBtnAlert(Get.context, result.statusText, "재시도", reload);
      return;
    } else if (!result.body.result) {
      showOneBtnAlert(Get.context, result.body.msg, "재시도", reload);
      return;
    }

    reload();
  }
}
