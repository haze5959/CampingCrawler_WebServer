import 'package:good_place_camp/Model/CampArea.dart';

class CampInfo {
  final String name;
  final String desc;
  final String addr;
  final double lat;
  final double lon;
  final CampArea area;
  final String homepageUrl;
  final String reservationUrl;
  final String reservationOpen;

  CampInfo(
    this.name,
    this.desc,
    this.addr,
    this.lat,
    this.lon,
    this.area,
    this.homepageUrl,
    this.reservationUrl,
    this.reservationOpen,
  );

  CampInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        desc = json['desc'],
        addr = json['addr'],
        lat = json['lat'],
        lon = json['lon'],
        area = fromString(json['area']),
        homepageUrl = json['homepage_url'],
        reservationUrl = json['reservation_url'],
        reservationOpen = json['reservation_open'];

  static Map<String, CampInfo> fromJsonArr(jsonStr) {
    var campInfoMap = Map<String, CampInfo>();
    final maps = Map<String, dynamic>.from(jsonStr);
    for (final key in maps.keys) {
      final json = Map<String, dynamic>.from(maps[key]);
      campInfoMap[key] = CampInfo.fromJson(json);
    }

    return campInfoMap;
  }
}
