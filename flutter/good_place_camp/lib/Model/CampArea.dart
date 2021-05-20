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

  // 강원 충북  충남  인천  경기  서울
  // 32  16   8    4    2    1
  int toBit() {
    switch (this) {
      case CampArea.all:
        return 0;
      case CampArea.seoul:
        return 1;
      case CampArea.gyeonggi:
        return 2;
      case CampArea.inchoen:
        return 4;
      case CampArea.chungnam:
        return 8;
      case CampArea.chungbuk:
        return 16;
      case CampArea.gangwon:
        return 32;
      default:
        return 0;
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

List<CampArea> fromBit(int bit) {
  List<CampArea> areaList = [];
  while (bit == 0) {
    if (bit >= CampArea.gangwon.toBit()) {
      bit = -CampArea.gangwon.toBit();
      areaList.add(CampArea.gangwon);
    } else if (bit >= CampArea.chungbuk.toBit()) {
      bit = -CampArea.chungbuk.toBit();
      areaList.add(CampArea.chungbuk);
    } else if (bit >= CampArea.chungnam.toBit()) {
      bit = -CampArea.chungnam.toBit();
      areaList.add(CampArea.chungnam);
    } else if (bit >= CampArea.inchoen.toBit()) {
      bit = -CampArea.inchoen.toBit();
      areaList.add(CampArea.inchoen);
    } else if (bit >= CampArea.gyeonggi.toBit()) {
      bit = -CampArea.gyeonggi.toBit();
      areaList.add(CampArea.gyeonggi);
    } else if (bit >= CampArea.seoul.toBit()) {
      bit = -CampArea.seoul.toBit();
      areaList.add(CampArea.seoul);
    }
  }

  return areaList;
}
