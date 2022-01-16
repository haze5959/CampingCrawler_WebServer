// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CampUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampUserInfo _$CampUserInfoFromJson(Map<String, dynamic> json) => CampUserInfo(
      nick: json['nick'] as String,
      profileUrl: json['profile_url'] as String,
      level: $enumDecode(_$CampRatingEnumMap, json['level']),
      areaBit: json['area_bit'] as int,
      usePushSubscription: json['use_push_subscription'] as bool,
      usePushAreaOnHoliday: json['use_push_area_on_holiday'] as bool,
      usePushSiteOnHoliday: json['use_push_site_on_holiday'] as bool,
      usePushReservationDay: json['use_push_reservation_day'] as bool,
      usePushNotice: json['use_push_notice'] as bool,
      favoriteList: (json['favorite_list'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CampUserInfoToJson(CampUserInfo instance) =>
    <String, dynamic>{
      'nick': instance.nick,
      'profile_url': instance.profileUrl,
      'level': _$CampRatingEnumMap[instance.level],
      'area_bit': instance.areaBit,
      'use_push_subscription': instance.usePushSubscription,
      'use_push_area_on_holiday': instance.usePushAreaOnHoliday,
      'use_push_site_on_holiday': instance.usePushSiteOnHoliday,
      'use_push_reservation_day': instance.usePushReservationDay,
      'use_push_notice': instance.usePushNotice,
      'favorite_list': instance.favoriteList,
    };

const _$CampRatingEnumMap = {
  CampRating.level01: 'level01',
  CampRating.level02: 'level02',
  CampRating.level03: 'level03',
  CampRating.owner: 'owner',
};
