import 'package:json_annotation/json_annotation.dart';

// Model
import 'package:good_place_camp/Model/CampInfo.dart';

part 'SiteInfo.g.dart';

abstract class SiteInfo {
  final String site;

  SiteInfo({required this.site});
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SiteDateInfo implements SiteInfo {
  final String site;
  final List<String> availDates;
  final String updatedDate;

  SiteDateInfo(
    this.site,
    this.availDates,
    this.updatedDate,
  );

  factory SiteDateInfo.fromJson(Map<String, dynamic> json) =>
      _$SiteDateInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SiteDateInfoToJson(this);
}

class ReservationInfo implements SiteInfo {
  final String site;
  final String desc;

  ReservationInfo(this.site, this.desc);
}

@JsonSerializable()
class SiteDetailInfo {
  final SiteDateInfo site;
  final CampInfo camp;
  final Map<String, String> holiday;

  SiteDetailInfo(
      {required this.site, required this.camp, required this.holiday});

  factory SiteDetailInfo.fromJson(Map<String, dynamic> json) =>
      _$SiteDetailInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SiteDetailInfoToJson(this);
}

@JsonSerializable()
class SiteListInfo {
  final List<SiteDateInfo> sites;
  final Map<String, String> holiday;

  SiteListInfo({required this.sites, required this.holiday});

  factory SiteListInfo.fromJson(Map<String, dynamic> json) =>
      _$SiteListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SiteListInfoToJson(this);
}
