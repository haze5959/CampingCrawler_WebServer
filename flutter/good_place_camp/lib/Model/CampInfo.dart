import 'package:json_annotation/json_annotation.dart';

part 'CampInfo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CampInfo {
  final String name;
  final String desc;
  final String addr;
  final String phone;
  final double lat;
  final double lon;
  final int area;
  final String homepageUrl;
  final String reservationUrl;
  final String reservationOpen;

  CampInfo({
    required this.name,
    required this.desc,
    required this.addr,
    required this.phone,
    required this.lat,
    required this.lon,
    required this.area,
    required this.homepageUrl,
    required this.reservationUrl,
    required this.reservationOpen,
  });

  factory CampInfo.fromJson(Map<String, dynamic> json) =>
      _$CampInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CampInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CampSimpleInfo {
  final String key;
  final String name;
  final String addr;
  final int areaBit;
  final String reservationOpen;

  CampSimpleInfo({
    required this.key,
    required this.name,
    required this.addr,
    required this.areaBit,
    required this.reservationOpen,
  });

  factory CampSimpleInfo.fromJson(Map<String, dynamic> json) =>
      _$CampSimpleInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CampSimpleInfoToJson(this);
}

Map<String, CampSimpleInfo> toCampInfoMap(List<CampSimpleInfo> list) {
  Map<String, CampSimpleInfo> infoMap = Map<String, CampSimpleInfo>();

  for (var info in list) {
    infoMap[info.key] = info;
  }

  return infoMap;
}
