// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CampUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampUserInfo _$CampUserInfoFromJson(Map<String, dynamic> json) => CampUserInfo(
      nick: json['nick'] as String?,
      level: $enumDecodeNullable(_$CampRatingEnumMap, json['level']),
      usePushSubscription: json['use_push_subscription'] as bool?,
      usePushAreaOnHoliday: json['use_push_area_on_holiday'] as bool?,
      usePushSiteOnHoliday: json['use_push_site_on_holiday'] as bool?,
      usePushReservationDay: json['use_push_reservation_day'] as bool?,
      usePushNotice: json['use_push_notice'] as bool?,
      favoriteList: (json['favorite'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      favoriteAreaList: (json['favorite_area'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$CampAreaEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$CampUserInfoToJson(CampUserInfo instance) =>
    <String, dynamic>{
      'nick': instance.nick,
      'level': _$CampRatingEnumMap[instance.level],
      'use_push_subscription': instance.usePushSubscription,
      'use_push_area_on_holiday': instance.usePushAreaOnHoliday,
      'use_push_site_on_holiday': instance.usePushSiteOnHoliday,
      'use_push_reservation_day': instance.usePushReservationDay,
      'use_push_notice': instance.usePushNotice,
      'favorite': instance.favoriteList,
      'favorite_area':
          instance.favoriteAreaList?.map((e) => _$CampAreaEnumMap[e]).toList(),
    };

const _$CampRatingEnumMap = {
  CampRating.level01: 'level01',
  CampRating.level02: 'level02',
  CampRating.level03: 'level03',
  CampRating.owner: 'owner',
};

const _$CampAreaEnumMap = {
  CampArea.seoul: 'seoul',
  CampArea.gyeonggi: 'gyeonggi',
  CampArea.inchoen: 'inchoen',
  CampArea.chungnam: 'chungnam',
  CampArea.chungbuk: 'chungbuk',
  CampArea.gangwon: 'gangwon',
  CampArea.all: 'all',
};
