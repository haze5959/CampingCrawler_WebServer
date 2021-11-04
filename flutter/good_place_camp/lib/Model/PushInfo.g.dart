// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PushInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushInfo _$PushInfoFromJson(Map<String, dynamic> json) => PushInfo(
      usePushOnArea: json['usePushOnArea'] as bool,
      useOnlyHolidayOnArea: json['useOnlyHolidayOnArea'] as bool,
      useOnlyInMonthOnArea: json['useOnlyInMonthOnArea'] as bool,
      usePushOnSite: json['usePushOnSite'] as bool,
      useOnlyHolidayOnSite: json['useOnlyHolidayOnSite'] as bool,
      useOnlyInMonthOnSite: json['useOnlyInMonthOnSite'] as bool,
      reservationDayPush: json['reservationDayPush'] as bool,
    );

Map<String, dynamic> _$PushInfoToJson(PushInfo instance) => <String, dynamic>{
      'usePushOnArea': instance.usePushOnArea,
      'useOnlyHolidayOnArea': instance.useOnlyHolidayOnArea,
      'useOnlyInMonthOnArea': instance.useOnlyInMonthOnArea,
      'usePushOnSite': instance.usePushOnSite,
      'useOnlyHolidayOnSite': instance.useOnlyHolidayOnSite,
      'useOnlyInMonthOnSite': instance.useOnlyInMonthOnSite,
      'reservationDayPush': instance.reservationDayPush,
    };
