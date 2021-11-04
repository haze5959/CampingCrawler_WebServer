// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SiteInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SiteDateInfo _$SiteDateInfoFromJson(Map<String, dynamic> json) => SiteDateInfo(
      json['site'] as String,
      (json['availDates'] as List<dynamic>).map((e) => e as String).toList(),
      json['updatedDate'] as String,
    );

Map<String, dynamic> _$SiteDateInfoToJson(SiteDateInfo instance) =>
    <String, dynamic>{
      'site': instance.site,
      'availDates': instance.availDates,
      'updatedDate': instance.updatedDate,
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
      sites: (json['sites'] as List<dynamic>)
          .map((e) => SiteDateInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      holiday: Map<String, String>.from(json['holiday'] as Map),
    );

Map<String, dynamic> _$SiteListInfoToJson(SiteListInfo instance) =>
    <String, dynamic>{
      'sites': instance.sites,
      'holiday': instance.holiday,
    };
