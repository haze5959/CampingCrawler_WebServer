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

  Future<Response<ServerResult<dynamic>>> getUserPushInfo(String token) =>
      get('/user/push/$token');

  Future<Response<ServerResult<dynamic>>> putUserNick(
          String token, String nick) =>
      put('/user/nick', {
        "token": token,
        "nick": nick,
      });

  Future<Response<ServerResult<dynamic>>> postUserArea(
          String token, int areaBit) =>
      post('/user/favorite', {
        "token": token,
        "area_bit": areaBit,
      });

  Future<Response<ServerResult<dynamic>>> postUserFavoriteList(
          String token, String campId) =>
      post('/user/favorite', {
        "token": token,
        "camp_id": campId,
      });

  Future<Response<ServerResult<dynamic>>> deleteUserFavoriteList(
          String token, String campId) =>
      delete('/user/favorite/$token?camp=$campId');

  Future<Response<ServerResult<dynamic>>> signOutUser(String token) =>
      delete('/user/$token');
}
