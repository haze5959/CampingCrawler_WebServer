// Model
import 'package:good_place_camp/Model/CampArea.dart';

class PushInfo {
  final List<CampArea> favoriteArea; // 토큰형식으로
  final bool usePushOnArea;
  final bool useOnlyHolidayOnArea; // 주말 빈자리만 알림
  final bool useOnlyInMonthOnArea; // 한달 내 자리알림만

  final List<String> favoriteSite; // 토큰형식으로
  final bool usePushOnSite;
  final bool useOnlyHolidayOnSite; // 주말 빈자리만 알림
  final bool useOnlyInMonthOnSite; // 한달 내 자리알림만
  final bool reservationDayPush; // 관심캠핑장만 알려줌

  PushInfo(
    this.favoriteArea,
    this.usePushOnArea,
    this.useOnlyHolidayOnArea,
    this.useOnlyInMonthOnArea,
    this.favoriteSite,
    this.usePushOnSite,
    this.useOnlyHolidayOnSite,
    this.useOnlyInMonthOnSite,
    this.reservationDayPush,
  );

  PushInfo._fromJson(Map<String, dynamic> json)
      : favoriteArea = CampAreaParse.fromJsonArr(json['favorite_area']),
        usePushOnArea = json['use_push_onArea'],
        useOnlyHolidayOnArea = json['useOnlyHolidayOnArea'],
        useOnlyInMonthOnArea = json['useOnlyInMonthOnArea'],
        favoriteSite = List<String>.from(json['favoriteSite']),
        usePushOnSite = json['usePushOnSite'],
        useOnlyHolidayOnSite = json['useOnlyHolidayOnSite'],
        useOnlyInMonthOnSite = json['useOnlyInMonthOnSite'],
        reservationDayPush = json['reservationDayPush'];

  static PushInfo fromJson(jsonStr) {
    final map = Map<String, dynamic>.from(jsonStr);
    return PushInfo._fromJson(map);
  }
}
