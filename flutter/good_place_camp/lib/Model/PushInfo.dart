import 'package:json_annotation/json_annotation.dart';

part 'PushInfo.g.dart';

@JsonSerializable()
class PushInfo {
  bool usePushOnArea;
  bool useOnlyHolidayOnArea; // 주말 빈자리만 알림
  bool useOnlyInMonthOnArea; // 한달 내 자리알림만

  bool usePushOnSite;
  bool useOnlyHolidayOnSite; // 주말 빈자리만 알림
  bool useOnlyInMonthOnSite; // 한달 내 자리알림만
  bool reservationDayPush; // 관심캠핑장만 알려줌

  PushInfo({
    required this.usePushOnArea,
    required this.useOnlyHolidayOnArea,
    required this.useOnlyInMonthOnArea,
    required this.usePushOnSite,
    required this.useOnlyHolidayOnSite,
    required this.useOnlyInMonthOnSite,
    required this.reservationDayPush,
  });

  factory PushInfo.fromJson(Map<String, dynamic> json) => _$PushInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PushInfoToJson(this);

  // PushInfo._fromJson(Map<String, dynamic> json)
  //     : usePushOnArea = json['use_push_on_area'],
  //       useOnlyHolidayOnArea = json['use_only_holiday_on_area'],
  //       useOnlyInMonthOnArea = json['use_only_in_month_on_area'],
  //       usePushOnSite = json['use_push_on_site'],
  //       useOnlyHolidayOnSite = json['use_only_holiday_on_site'],
  //       useOnlyInMonthOnSite = json['use_only_in_month_on_site'],
  //       reservationDayPush = json['use_reservation_day_push'];
}
