// Model
import 'package:good_place_camp/Model/CampArea.dart';

class CampUser {
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

  CampUser(
    this.id,
    this.nick,
    this.level,
    this.myArea,
    this.favoriteList,
  );

  CampUser.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nick = json['nick'],
        level = json['level'],
        myArea = json['area'],
        favoriteList = json['favorite'];

  static Map<String, CampUser> fromJsonArr(jsonStr) {
    var userMap = Map<String, CampUser>();
    final maps = Map<String, dynamic>.from(jsonStr);
    for (final key in maps.keys) {
      final json = Map<String, dynamic>.from(maps[key]);
      userMap[key] = CampUser.fromJson(json);
    }

    return userMap;
  }
}
