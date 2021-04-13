import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Model
import 'package:good_place_camp/Model/CampArea.dart';

class User {
  final int id;
  final String nick;
  final int level;
  final List<CampArea> myArea;
  final List<String> favoriteList;

  // RxList<String> favoriteList = () {
  //   final prefs = SharedPreferences.getInstance();
  //   prefs.then((value) {
  //     final list = value.getStringList("CAMP_FAVORITE");
  //     if (list != null) {
  //       Constants.favoriteList.addAll(list);
  //     }
  //   });

  //   return RxList<String>();
  // }();

  User(
    this.id,
    this.nick,
    this.level,
    this.myArea,
    this.favoriteList,
  );

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nick = json['nick'],
        level = json['level'],
        myArea = json['area'],
        favoriteList = json['favorite'];

  static Map<String, User> fromJsonArr(jsonStr) {
    var userMap = Map<String, User>();
    final maps = Map<String, dynamic>.from(jsonStr);
    for (final key in maps.keys) {
      final json = Map<String, dynamic>.from(maps[key]);
      userMap[key] = User.fromJson(json);
    }

    return userMap;
  }
}
