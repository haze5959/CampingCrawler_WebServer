import 'package:get/get.dart';

// Model
import 'package:good_place_camp/Model/ServerResult.dart';

class UserRepository extends GetConnect {
  @override
  UserRepository() {
    httpClient.defaultDecoder = ServerResult.fromJson;
    httpClient.baseUrl = 'http://haze5959.iptime.org:8000';
  }

  // 만약 해당 토큰에 관한 유저정보가 없다면 새로 만든다.
  Future<Response<ServerResult<dynamic>>> getUserInfo(String token) =>
      get('/user/$token');

  Future<Response<ServerResult<dynamic>>> getUserFavoriteList(String token) =>
      get('/user/favorite/$token');

  Future<Response<ServerResult<dynamic>>> putUserNick(
          String token, String nick) =>
      put('/user/nick', {
        "token": token,
        "nick": nick,
      });

  Future<Response<ServerResult<dynamic>>> putSnsInterworking(
          String token, String sns) =>
      put('/user/sns', {
        "token": token,
        "sns": sns,
      });

  // SNS 연동이 하나만 남았다면 계정이 삭제된다고 꼭 명시해야한다!
  Future<Response<ServerResult<dynamic>>> deleteSnsInterworking(
          String token, String sns) =>
      delete('/user/sns/$token?camp=$sns');

  Future<Response<ServerResult<dynamic>>> postUserFavoriteList(
          String token, String campId) =>
      post('/user/favorite', {
        "token": token,
        "camp_id": campId,
      });

  Future<Response<ServerResult<dynamic>>> deleteUserFavoriteList(
          String token, String campId) =>
      delete('/user/favorite/$token?camp=$campId');

  Future<Response<ServerResult<dynamic>>> getPushInfoWith(String token) =>
      get('/user/push/$token');
}
