// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CampInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampInfo _$CampInfoFromJson(Map<String, dynamic> json) => CampInfo(
      name: json['name'] as String,
      desc: json['desc'] as String,
      addr: json['addr'] as String,
      phone: json['phone'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      area: json['area'] as int,
      homepageUrl: json['homepage_url'] as String,
      reservationUrl: json['reservation_url'] as String,
      reservationOpen: json['reservation_open'] as String,
    );

Map<String, dynamic> _$CampInfoToJson(CampInfo instance) => <String, dynamic>{
      'name': instance.name,
      'desc': instance.desc,
      'addr': instance.addr,
      'phone': instance.phone,
      'lat': instance.lat,
      'lon': instance.lon,
      'area': instance.area,
      'homepage_url': instance.homepageUrl,
      'reservation_url': instance.reservationUrl,
      'reservation_open': instance.reservationOpen,
    };

CampSimpleInfo _$CampSimpleInfoFromJson(Map<String, dynamic> json) =>
    CampSimpleInfo(
      key: json['key'] as String,
      name: json['name'] as String,
      addr: json['addr'] as String,
      areaBit: json['area_bit'] as int,
      reservationOpen: json['reservation_open'] as String,
    );

Map<String, dynamic> _$CampSimpleInfoToJson(CampSimpleInfo instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'addr': instance.addr,
      'area_bit': instance.areaBit,
      'reservation_open': instance.reservationOpen,
    };
