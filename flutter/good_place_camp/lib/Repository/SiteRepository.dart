import 'package:get/get.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';
import 'package:good_place_camp/Model/CampArea.dart';

class SiteRepository extends GetConnect {
  @override
  SiteRepository() {
    // 모든 요청은 jsonEncode로 CasesModel.fromJson()를 거칩니다.
    httpClient.defaultDecoder = SiteInfo.fromJsonArr;
    httpClient.baseUrl = 'http://haze5959.iptime.org:8000';
  }

  Future<Response<List<SiteInfo>>> getAllSiteInfo() => get('/camp');

  Future<Response<List<SiteInfo>>> getSiteInfo(List<CampArea> areaList) {
    var url = "/camp";
    Iterable<int>.generate(areaList.length).forEach((index) => {
          if (index == 0)
            url += "?area[]=${areaList[index].toString()}"
          else
            url += "&area[]=${areaList[index].toString()}"
        });

    return get(url);
  }
}
