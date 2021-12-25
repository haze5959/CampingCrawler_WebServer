enum CampArea { seoul, gyeonggi, inchoen, chungnam, chungbuk, gangwon }

extension CampAreaParse on CampArea {
  String toAreaString() {
    switch (this) {
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
}

CampArea fromAreaInt(int areaInt) {
  switch (areaInt) {
    case 1:
      return CampArea.seoul;
    case 2:
      return CampArea.gyeonggi;
    case 4:
      return CampArea.inchoen;
    case 8:
      return CampArea.chungnam;
    case 16:
      return CampArea.chungbuk;
    case 32:
      return CampArea.gangwon;
    default:
      return CampArea.seoul;
  }
}

int toAreaBit(Set<CampArea> areaSet) {
  if (areaSet.isEmpty) {
    return 0;
  } else {
    return areaSet
        .map((element) => element.toBit())
        .reduce((value, element) => value + element);
  }
}

Set<CampArea> fromBit(int bit) {
  Set<CampArea> areaSet = {};
  if (bit == 0) {
    // 전지역 설정
    areaSet.addAll(CampArea.values);
  } else {
    while (bit > 0) {
      if (bit >= CampArea.gangwon.toBit()) {
        bit -= CampArea.gangwon.toBit();
        areaSet.add(CampArea.gangwon);
      } else if (bit >= CampArea.chungbuk.toBit()) {
        bit -= CampArea.chungbuk.toBit();
        areaSet.add(CampArea.chungbuk);
      } else if (bit >= CampArea.chungnam.toBit()) {
        bit -= CampArea.chungnam.toBit();
        areaSet.add(CampArea.chungnam);
      } else if (bit >= CampArea.inchoen.toBit()) {
        bit -= CampArea.inchoen.toBit();        
        areaSet.add(CampArea.inchoen);
      } else if (bit >= CampArea.gyeonggi.toBit()) {
        bit -= CampArea.gyeonggi.toBit();
        areaSet.add(CampArea.gyeonggi);
      } else if (bit >= CampArea.seoul.toBit()) {
        bit -= CampArea.seoul.toBit();
        areaSet.add(CampArea.seoul);
      }
    }
  }

  return areaSet;
}
