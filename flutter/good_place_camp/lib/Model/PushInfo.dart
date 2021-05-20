// Model
import 'package:good_place_camp/Model/CampArea.dart';

class PushInfo {
  List<CampArea> favoriteArea; // 토큰형식으로
  bool usePushOnArea;
  bool useOnlyHolidayOnArea; // 주말 빈자리만 알림
  bool useOnlyInMonthOnArea; // 한달 내 자리알림만

  List<String> favoriteSite; // 토큰형식으로
  bool usePushOnSite;
  bool useOnlyHolidayOnSite; // 주말 빈자리만 알림
  bool useOnlyInMonthOnSite; // 한달 내 자리알림만
  bool reservationDayPush; // 관심캠핑장만 알려줌

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
        usePushOnArea = json['use_push_on_area'],
        useOnlyHolidayOnArea = json['use_only_holiday_on_area'],
        useOnlyInMonthOnArea = json['use_only_in_month_on_area'],
        favoriteSite = List<String>.from(json['favorite_site']),
        usePushOnSite = json['use_push_on_site'],
        useOnlyHolidayOnSite = json['use_only_holiday_on_site'],
        useOnlyInMonthOnSite = json['use_only_in_month_on_site'],
        reservationDayPush = json['reservation_day_push'];

  static PushInfo fromJson(jsonStr) {
    final map = Map<String, dynamic>.from(jsonStr);
    return PushInfo._fromJson(map);
  }
}
