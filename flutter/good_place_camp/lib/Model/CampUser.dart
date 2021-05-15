import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:get/get.dart';

// Repository
import 'package:good_place_camp/Repository/UserRepository.dart';

// Model
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CampUser {
  bool isLogin;
  User firebaseUser;
  CampUserInfo info = CampUserInfo();

  CampUser(this.isLogin);

  UserRepository repo = UserRepository();

  Future<bool> login(User user) async {
    firebaseUser = user;
    final result = await reloadInfo();
    if (result) {
      isLogin = true;
      return true;
    } else {
      logout();
      return false;
    }
  }

  void logout() {
    Constants.auth.signOut();
    isLogin = false;
    firebaseUser = null;
    info = CampUserInfo();
    Constants.user.refresh();
  }

  Future<bool> signout() async {
    final idToken = await firebaseUser.getIdToken();
    final result = await repo.signOutUser(idToken);
    if (result.hasError) {
      showOneBtnAlert(Get.context, result.statusText, "확인", () {});
      return false;
    } else if (!result.body.result) {
      showOneBtnAlert(Get.context, result.body.msg, "확인", () {});
      return false;
    }

    await firebaseUser.delete();
    isLogin = false;
    firebaseUser = null;
    info = CampUserInfo();
    Constants.user.refresh();
    return true;
  }

  Future<bool> reloadInfo() async {
    try {
      final idToken = await firebaseUser.getIdToken();
      // 유저정보 가져오는 로직
      final result = await repo.getUserInfo(idToken);
      if (result.hasError) {
        showOneBtnAlert(Get.context, result.statusText, "확인", () {});
        return false;
      } else if (!result.body.result) {
        showOneBtnAlert(Get.context, result.body.msg, "확인", () {});
        return false;
      }

      info = CampUserInfo.fromJson(result.body.data);
      Constants.user.refresh();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> saveMyArea() async {
    final idToken = await firebaseUser.getIdToken();
    final areaBit = 0; // 지역 비트 연산 값 넣기!!!

    final result = await repo.postUserArea(idToken, areaBit);
    if (result.hasError) {
      showOneBtnAlert(Get.context, result.statusText, "확인", () {});
      return false;
    } else if (!result.body.result) {
      showOneBtnAlert(Get.context, result.body.msg, "확인", () {});
      return false;
    }

    return true;
  }
}

class CampUserInfo {
  String nick;
  CampRating level;
  List<CampArea> myArea = [];
  bool usePushSubscription = false;
  List<String> favoriteList = [];

  CampUserInfo();

  CampUserInfo.fromJson(Map<String, dynamic> json)
      : nick = json['nick'],
        level = CampRatingParser.fromInt(json['auth_level']);
  // myArea = json['area'];
  // usePushSubscription = json['push_subscription'];
  // favoriteList = json['favoriteList']

  static Map<String, CampUserInfo> fromJsonArr(jsonStr) {
    var userMap = Map<String, CampUserInfo>();
    final maps = Map<String, dynamic>.from(jsonStr);
    for (final key in maps.keys) {
      final json = Map<String, dynamic>.from(maps[key]);
      userMap[key] = CampUserInfo.fromJson(json);
    }

    return userMap;
  }
}

enum CampRating { level01, level02, level03, owner }

extension CampRatingParser on CampRating {
  static CampRating fromInt(int val) {
    switch (val) {
      case 0:
        return CampRating.level01;
      case 1:
        return CampRating.level02;
      case 2:
        return CampRating.level03;
      case 3:
        return CampRating.owner;
      default:
        return CampRating.level01;
    }
  }

  String getLevelText() {
    switch (this) {
      case CampRating.level01:
        return "노지캠퍼";
      case CampRating.level02:
        return "명당캠퍼 🏕";
      case CampRating.level03:
        return "카라반캠퍼 🏅";
      case CampRating.owner:
        return "명당지기 🧑‍💻";
      default:
        return "노지캠퍼";
    }
  }
}
