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

extension CampAreaParse on CampArea {
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

  static List<CampArea> fromJsonArr(args) {
    final argList = List<String>.from(args);
    return argList.map((arg) => fromString(arg));
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
