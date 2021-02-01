import 'package:get/get.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class SiteRepository extends GetConnect {
  @override
  SiteRepository() {
    // 모든 요청은 jsonEncode로 CasesModel.fromJson()를 거칩니다.
    httpClient.defaultDecoder = SiteInfo.fromJsonArr;
    httpClient.baseUrl = 'http://haze5959.iptime.org:8000';
  }

  Future<Response<List<SiteInfo>>> getAllSiteInfo() => get('/camp');
}
