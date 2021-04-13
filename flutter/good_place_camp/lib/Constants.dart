import 'package:firebase_auth/firebase_auth.dart';

// Model
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:good_place_camp/Model/CampInfo.dart';
import 'package:good_place_camp/Model/User.dart';

const double MAX_WIDTH = 1000;
const double CALENDER_WIDTH = 320;
const double CARD_HEIGHT = 280;
const double MAIN_PADDING = 50;

const Duration timeOutSec = Duration(seconds: 30);

class Constants {
  static bool isPhoneSize = false;
  static Map<String, CampInfo> campInfo = {};
  static User user;
  static List<CampArea> selectedArea;

  static FirebaseAuth auth = FirebaseAuth.instance;
}
