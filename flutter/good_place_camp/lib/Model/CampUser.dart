import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

// Repository
import 'package:good_place_camp/Repository/UserRepository.dart';

// Model
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CampUser {
  bool isLogin;
  User? firebaseUser;
  CampUserInfo info = CampUserInfo();

  CampUser({required this.isLogin, this.firebaseUser});

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
    User? user = firebaseUser;
    if (user != null) {
      final idToken = await user.getIdToken();
      final result = await repo.signOutUser(idToken);
      if (result.hasError) {
        showOneBtnAlert(result.statusText, "확인", () {});
        return false;
      } else if (!result.body.result) {
        showOneBtnAlert(Get.context, result.body.msg, "확인", () {});
        return false;
      }

      isLogin = false;
      firebaseUser = null;
      info = CampUserInfo();
      Constants.user.refresh();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> reloadInfo() async {
    try {
      final idToken = await firebaseUser.getIdToken();
      // 유저정보 가져오는 로직
      final result = await repo.getUserInfo(idToken);
      if (result.hasError) {
        print("reloadInfo fail - " + result.statusText);
        showOneBtnAlert(Get.context, result.statusText, "확인", () {});
        return false;
      } else if (!result.body.result) {
        print("reloadInfo result fail - " + result.body.msg);
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
}

@JsonSerializable()
class CampUserInfo {
  String? nick;
  CampRating? level;
  bool? usePushSubscription = false; // TODO
  bool? usePushAreaOnHoliday = false;
  bool? usePushSiteOnHoliday = false;
  bool? usePushReservationDay = false;
  bool? usePushNotice = false;
  List<String>? favoriteList = [];
  List<CampArea>? favoriteAreaList = [];

  CampUserInfo(
      {this.nick,
      this.level,
      this.usePushSubscription,
      this.usePushAreaOnHoliday,
      this.usePushSiteOnHoliday,
      this.usePushReservationDay,
      this.usePushNotice,
      this.favoriteList,
      this.favoriteAreaList});

  factory CampUserInfo.fromJson(Map<String, dynamic> json) =>
      _$CampUserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CampUserInfoToJson(this);

  // CampUserInfo.fromJson(Map<String, dynamic> json) {
  //   final userJson = json['user'];
  //   nick = userJson['nick'];
  //   level = CampRatingParser.fromInt(userJson['auth_level']);
  //   favoriteAreaList = fromBit(userJson['area_bit']);
  //   usePushAreaOnHoliday = userJson['use_push_area_on_holiday'] == 1;
  //   usePushSiteOnHoliday = userJson['use_push_site_on_holiday'] == 1;
  //   usePushReservationDay = userJson['use_push_reservation_day'] == 1;
  //   usePushNotice = userJson['use_push_notice'] == 1;
  //   favoriteList = List<String>.from(json['favorite']);
  // }
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
