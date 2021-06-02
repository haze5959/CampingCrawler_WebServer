import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Model
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:good_place_camp/Model/CampInfo.dart';
import 'package:good_place_camp/Model/CampUser.dart';

const double MAX_WIDTH = 1000;
const double CALENDER_WIDTH = 320;
const double CARD_HEIGHT = 280;
const double MAIN_PADDING = 50;

const String MY_AREA_BIT_KEY = "MY_AREA_BIT_KEY";

const Duration timeOutSec = Duration(seconds: 30);

const String IMAGE_URL = "http://haze5959.iptime.org:5980/images";

class Constants {
  static bool isPhoneSize = false;
  static Map<String, CampInfo> campInfo = {};
  static Rx<CampUser> user = CampUser(false).obs;
  static RxList<CampArea> myArea = [].obs;
  static FirebaseAuth auth = FirebaseAuth.instance;
}
