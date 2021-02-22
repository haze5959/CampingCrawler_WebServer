import 'package:shared_preferences/shared_preferences.dart';

enum CampArea {
  all,
  seoul,
  gyeonggi,
  inchoen,
  chungnam,
  chungbuk,
  gangwon,
}

extension ParseToString on CampArea {
  String toAreaString() {
    switch (this) {
      case CampArea.all:
        return "전체";
      case CampArea.seoul:
        return "서울";
      case CampArea.gyeonggi:
        return "경기";
      case CampArea.inchoen:
        return "인천";
      case CampArea.chungnam:
        return "충남";
      case CampArea.chungbuk:
        return "충북";
      case CampArea.gangwon:
        return "강원";
      default:
        return "";
    }
  }
}

CampArea fromString(String str) {
  switch (str) {
    case "CampArea.seoul":
      return CampArea.seoul;
    case "CampArea.gyeonggi":
      return CampArea.gyeonggi;
    case "CampArea.inchoen":
      return CampArea.inchoen;
    case "CampArea.chungnam":
      return CampArea.chungnam;
    case "CampArea.chungbuk":
      return CampArea.chungbuk;
    case "CampArea.gangwon":
      return CampArea.gangwon;
    default:
      return CampArea.all;
  }
}

void saveCampAreaData(List<CampArea> areaList) async {
  // 값 저장
  final prefs = await SharedPreferences.getInstance();
  final areaListStr = areaList.map((area) => area.toString()).toList();

  prefs.setStringList("CAMP_AREA", areaListStr);
}

Future<List<CampArea>> getCampAreaData() async {
  // 값 로드
  final prefs = await SharedPreferences.getInstance();
  final areaListStr = prefs.getStringList("CAMP_AREA") ?? [];
  return areaListStr.map((areaStr) => fromString(areaStr)).toList();
}
