import 'package:good_place_camp/Model/CampArea.dart';

class CampInfo {
  final String name;
  final String desc;
  final String addr;
  final CampArea area;
  final String homepageUrl;
  final String reservationUrl;

  CampInfo(
    this.name,
    this.desc,
    this.addr,
    this.area,
    this.homepageUrl,
    this.reservationUrl,
  );

  CampInfo.fromJson(Map<String, String> json)
      : name = json['name'],
        desc = json['desc'],
        addr = json['addr'],
        area = fromString(json['area']),
        homepageUrl = json['homepage_url'],
        reservationUrl = json['reservation_url'];

  static Map<String, CampInfo> fromJsonArr(jsonStr) {
    var campInfoMap = Map<String, CampInfo>();
    final maps = Map<String, dynamic>.from(jsonStr);
    for (final key in maps.keys) {
      final json = Map<String, String>.from(maps[key]);
      campInfoMap[key] = CampInfo.fromJson(json);
    }

    return campInfoMap;
  }
}
