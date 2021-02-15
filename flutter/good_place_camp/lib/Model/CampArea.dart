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
