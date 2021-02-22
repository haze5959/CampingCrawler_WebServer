// Model
import 'package:good_place_camp/Model/CampArea.dart';

const double MAX_WIDTH = 1000;
const double CALENDER_WIDTH = 320;
const double CARD_HEIGHT = 280;
const double MAIN_PADDING = 50;

bool IS_PHONE_SIZE = false;
List<CampArea> SELECTED_AREA = [];

const CAMP_INFO = {
  "camp_munsoo": {
    "name": "문수골 힐링캠핑장 D-2 존",
    "desc":
        "바로 앞에 큰 저수지가 보이는 아름다운 뷰",
    "addr": "경기 김포시 월곶면 문수산로 104-107",
    "area": CampArea.gyeonggi,
    "homepage_url": "https://munsugolcamping.com/",
    "reservation_url": "https://forcamper.co.kr/campgrounds/1758"
  },
  "camp_tree": {
    "name": "트리캠핑장 B & C 존",
    "desc": "높은 곳에서 바다가 훤히 보이는 뷰",
    "addr": "인천 옹진군 영흥면 선재리 산13",
    "area": CampArea.inchoen,
    "homepage_url": "http://www.treecamping.net/",
    "reservation_url":
        "https://www.ddnayo.com/RsvSys/Calendar.aspx?id_hotel=1997"
  },
};
