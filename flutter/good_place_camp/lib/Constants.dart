import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Model
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:good_place_camp/Model/CampInfo.dart';
import 'package:good_place_camp/Model/CampUser.dart';

const double MAX_WIDTH = 1000;
const double HORIZE_INFO_MAX_WIDTH = 1500;
const double CALENDER_WIDTH = 320;
const double CARD_HEIGHT = 280;
const double CARD_WIDTH = 280;
const double CARD_SPACE = 15;
const double MAIN_PADDING = 50;

const String MY_AREA_BIT_KEY = "MY_AREA_BIT_KEY";

const String IMAGE_URL = "http://haze5959.iptime.org:5980/images";
const String BASE_URL = "http://haze5959.iptime.org:8000";
// const String BASE_URL = "http://localhost:8000"; // 테스트용

class Constants {
  static bool isPhoneSize = false;
  static Map<String, CampSimpleInfo> campInfoMap = {};
  static Rx<CampUser> user = CampUser(isLogin: false).obs;
  static RxList<CampArea> myArea = <CampArea>[].obs;
  static FirebaseAuth auth = FirebaseAuth.instance;
}
