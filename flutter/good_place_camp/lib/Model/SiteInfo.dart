class SiteInfo {
  final String site;
  final List<String> availDates;
  final String updatedDate;

  SiteInfo(
    this.site,
    this.availDates,
    this.updatedDate,
  );

  SiteInfo._fromJson(Map<String, dynamic> json)
      : site = json['site'],
        availDates = List<String>.from(json['availDates']),
        updatedDate = json['updatedDate'];

  static List<SiteInfo> fromJsonArr(jsonStr) {
    final list = List<Map<String, dynamic>>.from(jsonStr);
    final listSiteInfo = list.map((json) => SiteInfo._fromJson(json));
    return listSiteInfo.toList();
  }

  static SiteInfo fromJson(jsonStr) {
    final map = Map<String, dynamic>.from(jsonStr);
    return SiteInfo._fromJson(map);
  }
}
