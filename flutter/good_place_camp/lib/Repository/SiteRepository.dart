import 'package:get/get.dart';

// Model
import 'package:good_place_camp/Model/SiteInfo.dart';

class SiteRepository extends GetConnect {
  @override
  void onInit() {
    // 모든 요청은 jsonEncode로 CasesModel.fromJson()를 거칩니다.
    // httpClient.defaultDecoder = SiteInfo.fromJson;
    // httpClient.baseUrl = 'http://haze5959.iptime.org:8000/';
  }

  Future<Response<dynamic>> getAllSiteInfo() => get('http://haze5959.iptime.org:8000/camp');
}
