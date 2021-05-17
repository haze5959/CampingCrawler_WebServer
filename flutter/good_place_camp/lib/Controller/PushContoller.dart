import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Model
import 'package:good_place_camp/Model/PushInfo.dart';

// Repository
import 'package:good_place_camp/Repository/UserRepository.dart';

class PushContoller extends GetxController {
  final UserRepository repo = UserRepository();

  Rx<PushInfo> pushInfo = PushInfo(false, [], false, [], false).obs;
  RxBool isLoading = false.obs;

  @override
  void onReady() async {
    super.onReady();
  }

  void reload() async {
    isLoading.value = true;
    await Constants.user.value.reloadInfo();

    isLoading.value = false;
  }
}
