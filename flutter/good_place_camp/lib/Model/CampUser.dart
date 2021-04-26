// Model
import 'package:good_place_camp/Model/CampArea.dart';

class CampUser {
  String token;
  int id;
  String nick;
  int level;
  List<CampArea> myArea;
  List<String> favoriteList;
  bool usePushSubscription;

  CampUser(
    this.id,
    this.nick,
    this.level,
    this.myArea,
    this.favoriteList,
    this.usePushSubscription,
  );

  CampUser.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nick = json['nick'],
        level = json['level'],
        myArea = json['area'],
        favoriteList = json['favorite'],
        usePushSubscription = json['push_subscription'];

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
