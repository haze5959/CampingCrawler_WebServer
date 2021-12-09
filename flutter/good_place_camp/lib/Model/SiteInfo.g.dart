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
      site: SiteDateInfo.fromJson(json['site'] as Map<String, dynamic>),
      camp: CampInfo.fromJson(json['camp'] as Map<String, dynamic>),
      holiday: Map<String, String>.from(json['holiday'] as Map),
    );

Map<String, dynamic> _$SiteDetailInfoToJson(SiteDetailInfo instance) =>
    <String, dynamic>{
      'site': instance.site,
      'camp': instance.camp,
      'holiday': instance.holiday,
    };

SiteListInfo _$SiteListInfoFromJson(Map<String, dynamic> json) => SiteListInfo(
      camps: (json['camps'] as List<dynamic>)
          .map((e) => SiteDateInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      holiday: Map<String, String>.from(json['holiday'] as Map),
    );

Map<String, dynamic> _$SiteListInfoToJson(SiteListInfo instance) =>
    <String, dynamic>{
      'camps': instance.camps,
      'holiday': instance.holiday,
    };
