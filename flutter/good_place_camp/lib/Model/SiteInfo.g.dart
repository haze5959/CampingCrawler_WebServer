// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SiteInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SiteDateInfo _$SiteDateInfoFromJson(Map<String, dynamic> json) => SiteDateInfo(
      json['site'] as String,
      (json['avail_dates'] as List<dynamic>).map((e) => e as String).toList(),
      json['updated_date'] as String,
    );

Map<String, dynamic> _$SiteDateInfoToJson(SiteDateInfo instance) =>
    <String, dynamic>{
      'site': instance.site,
      'avail_dates': instance.availDates,
      'updated_date': instance.updatedDate,
    };

SiteDetailInfo _$SiteDetailInfoFromJson(Map<String, dynamic> json) =>
    SiteDetailInfo(
      camp: SiteDateInfo.fromJson(json['camp'] as Map<String, dynamic>),
      info: CampInfo.fromJson(json['info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SiteDetailInfoToJson(SiteDetailInfo instance) =>
    <String, dynamic>{
      'camp': instance.camp,
      'info': instance.info,
    };

SiteListInfo _$SiteListInfoFromJson(Map<String, dynamic> json) => SiteListInfo(
      camps: (json['camps'] as List<dynamic>)
          .map((e) => SiteDateInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SiteListInfoToJson(SiteListInfo instance) =>
    <String, dynamic>{
      'camps': instance.camps,
    };
