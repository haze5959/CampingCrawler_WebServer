import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Model
import 'package:good_place_camp/Model/ServerResult.dart';
import 'package:good_place_camp/Model/CampArea.dart';

class SiteRepository extends GetConnect {
  @override
  SiteRepository() {
    httpClient.defaultDecoder = ServerResult.fromJson;
    httpClient.baseUrl = 'http://haze5959.iptime.org:8000';
  }

  Future<Response<ServerResult<dynamic>>> getAllSiteInfo() =>
      get<ServerResult<dynamic>>('/camp')
          .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  Future<Response<ServerResult<dynamic>>> getSiteInfoWith(String site) =>
      get<ServerResult<dynamic>>('/camp/$site')
          .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  Future<Response<ServerResult<dynamic>>> getSiteInfo(List<CampArea> areaList) {
    var url = "/camp";

    if (areaList.length > 0) {
      final bit = areaList
          .map((element) => element.toBit())
          .reduce((value, element) => value + element);
      url += "?area_bit=$bit";
    }

    return get<ServerResult<dynamic>>(url)
        .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);
  }

  Future<Response<ServerResult<dynamic>>> getAllSiteJson() =>
      get<ServerResult<dynamic>>('/info', contentType: "application/json")
          .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);
}
