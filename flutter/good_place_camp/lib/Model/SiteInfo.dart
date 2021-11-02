import 'package:json_annotation/json_annotation.dart';

abstract class SiteInfo {
  final String site;

  SiteInfo({required this.site});
}

@JsonSerializable()
class SiteDateInfo implements SiteInfo {
  final String site;
  final List<String> availDates;
  final String updatedDate;

  SiteDateInfo(
    this.site,
    this.availDates,
    this.updatedDate,
  );

  factory SiteDateInfo.fromJson(Map<String, dynamic> json) => _$SiteDateInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SiteDateInfoToJson(this);
}

class ReservationInfo implements SiteInfo {
  final String site;
  final String desc;

  ReservationInfo(this.site, this.desc);
}
