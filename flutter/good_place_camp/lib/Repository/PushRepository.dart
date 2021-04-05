import 'package:get/get.dart';

// Model
import 'package:good_place_camp/Model/ServerResult.dart';

class PushRepository extends GetConnect {
  @override
  PushRepository() {
    // 모든 요청은 jsonEncode로 CasesModel.fromJson()를 거칩니다.
    httpClient.defaultDecoder = ServerResult.fromJson;
    httpClient.baseUrl = 'http://haze5959.iptime.org:8000';
  }

  Future<Response<ServerResult<dynamic>>> getPushInfoWith(int id) =>
      get('/push/$id');
}
