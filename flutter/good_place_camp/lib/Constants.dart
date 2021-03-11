// Model
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:good_place_camp/Model/CampInfo.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double MAX_WIDTH = 1000;
const double CALENDER_WIDTH = 320;
const double CARD_HEIGHT = 280;
const double MAIN_PADDING = 50;

class Constants {
  static bool isPhoneSize = false;
  static List<CampArea> selectedArea = [];
  static Map<String, CampInfo> campInfo = {};

  static RxList<String> favoriteList = () {
    final prefs = SharedPreferences.getInstance();
    prefs.then((value) {
      Constants.favoriteList.addAll(value.getStringList("CAMP_FAVORITE"));
    });

    return RxList<String>();
  }();
}
