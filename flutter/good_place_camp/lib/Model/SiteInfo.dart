class SiteInfo {
  final String site;
  final List<String> availDates;
  final String updatedDate;

  SiteInfo(
    this.site,
    this.availDates,
    this.updatedDate,
  );

  SiteInfo.fromJson(Map<String, dynamic> json)
      : site = json['site'],
        availDates = List<String>.from(json['availDates']),
        updatedDate = json['updatedDate'];

  static List<SiteInfo> fromJsonArr(jsonStr) {
    var list = List<Map<String, dynamic>>.from(jsonStr);
    var listSiteInfo = list.map((json) => SiteInfo.fromJson(json));
    return listSiteInfo.toList();
  }
}
