import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:json_annotation/json_annotation.dart';

// Repository
import 'package:good_place_camp/Repository/ApiRepository.dart';

// Model
import 'package:good_place_camp/Model/CampArea.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'CampUser.g.dart';

class CampUser {
  bool isLogin;
  User? firebaseUser;
  CampUserInfo? info;

  CampUser({required this.isLogin, this.firebaseUser});

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
    info = null;
    Constants.user.refresh();
  }

  Future<bool> signout() async {
    User? user = firebaseUser;
    if (user != null) {
      final idToken = await user.getIdToken();
      final res = await ApiRepo.user.deleteUser(idToken);
      if (!res.result) {
        showServerErrorAlert(res.msg, false);
        return false;
      }

      isLogin = false;
      firebaseUser = null;
      info = null;
      Constants.user.refresh();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> reloadInfo() async {
    User? user = firebaseUser;
    if (user == null) {
      return false;
    }

    try {
      final idToken = await user.getIdToken();
      // 유저정보 가져오는 로직
      final res = await ApiRepo.user.getUserInfo(idToken);

      if (!res.result) {
        print("reloadInfo result fail - " + res.msg);
        showServerErrorAlert(res.msg, false);
        return false;
      }

      final data = res.data!;
      info = data;
      Constants.user.refresh();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String>? getToken() {
    final user = firebaseUser;
    if (isLogin && user != null) {
      return user.getIdToken();
    } else {
      return null;
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CampUserInfo {
  String nick;
  String profileUrl;
  CampRating level;
  int areaBit;
  bool usePushSubscription; // TODO
  bool usePushAreaOnHoliday;
  bool usePushSiteOnHoliday;
  bool usePushReservationDay;
  bool usePushNotice;
  List<String> favoriteList;

  CampUserInfo(
      {required this.nick,
      required this.profileUrl,
      required this.level,
      required this.areaBit,
      required this.usePushSubscription,
      required this.usePushAreaOnHoliday,
      required this.usePushSiteOnHoliday,
      required this.usePushReservationDay,
      required this.usePushNotice,
      required this.favoriteList});

  factory CampUserInfo.fromJson(Map<String, dynamic> json) =>
      _$CampUserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CampUserInfoToJson(this);
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
        return "camp_level_1".tr;
      case CampRating.level02:
        return "camp_level_2".tr;
      case CampRating.level03:
        return "camp_level_3".tr;
      case CampRating.owner:
        return "camp_level_4".tr;
      default:
        return "camp_level_1".tr;
    }
  }
}
