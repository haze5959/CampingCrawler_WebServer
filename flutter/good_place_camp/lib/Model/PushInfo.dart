import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PushInfo {
  final bool usePushOnArea;
  final bool useOnlyHolidayOnArea; // 주말 빈자리만 알림
  final bool useOnlyInMonthOnArea; // 한달 내 자리알림만

  final bool usePushOnSite;
  final bool useOnlyHolidayOnSite; // 주말 빈자리만 알림
  final bool useOnlyInMonthOnSite; // 한달 내 자리알림만
  final bool reservationDayPush; // 관심캠핑장만 알려줌

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
