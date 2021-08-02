abstract class SiteInfo {
  String site;
}

class SiteDateInfo implements SiteInfo {
  String site;
  final List<String> availDates;
  final String updatedDate;

  SiteDateInfo(
    this.site,
    this.availDates,
    this.updatedDate,
  );

  SiteDateInfo._fromJson(Map<String, dynamic> json)
      : site = json['site'],
        availDates = List<String>.from(json['availDates']),
        updatedDate = json['updatedDate'];

  static List<SiteDateInfo> fromJsonArr(jsonStr) {
    final list = List<Map<String, dynamic>>.from(jsonStr);
    final listSiteInfo = list.map((json) => SiteDateInfo._fromJson(json));
    return listSiteInfo.toList();
  }

  static SiteDateInfo fromJson(jsonStr) {
    final map = Map<String, dynamic>.from(jsonStr);
    return SiteDateInfo._fromJson(map);
  }
}

class ReservationInfo implements SiteInfo {
  String site;
  final String desc;

  ReservationInfo(this.site, this.desc);
}
