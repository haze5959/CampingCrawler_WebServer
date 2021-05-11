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
  CampUserInfo info;

  CampUser(this.isLogin);

  UserRepository repo = UserRepository();

  Future<bool> login(User user) async {
    firebaseUser = user;
    isLogin = true;
    return reloadInfo();
  }

  void logout() {
    Constants.auth.signOut();
    isLogin = false;
    firebaseUser = null;
    info = null;
    Constants.user.refresh();
  }

  Future<bool> reloadInfo() async {
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
  }
}

class CampUserInfo {
  int id;
  String nick;
  int level;
  List<CampArea> myArea;
  List<String> favoriteList;
  bool usePushSubscription;

  CampUserInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nick = json['nick'],
        level = json['level'],
        myArea = json['area'],
        favoriteList = json['favorite'],
        usePushSubscription = json['push_subscription'];

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
