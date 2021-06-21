import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Model
import 'package:good_place_camp/Model/ServerResult.dart';
import 'package:good_place_camp/Model/PushInfo.dart';

class UserRepository extends GetConnect {
  @override
  UserRepository() {
    httpClient.defaultDecoder = ServerResult.fromJson;
    httpClient.baseUrl = BASE_URL;
  }

  // 만약 해당 토큰에 관한 유저정보가 없다면 새로 만든다.
  Future<Response<ServerResult<dynamic>>> getUserInfo(String token) =>
      get<ServerResult<dynamic>>('/user/$token')
          .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  Future<Response<ServerResult<dynamic>>> getUserFavoriteList(String token) =>
      get<ServerResult<dynamic>>('/user/favorite/$token')
          .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  Future<Response<ServerResult<dynamic>>> getUserPushInfo(String token) =>
      get<ServerResult<dynamic>>('/user/push/$token')
          .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  Future<Response<ServerResult<dynamic>>> putUserNick(
          String token, String nick) =>
      put<ServerResult<dynamic>>('/user/nick', {
        "token": token,
        "nick": nick,
      }).timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  Future<Response<ServerResult<dynamic>>> putPushInfo(
          String token, PushInfo info) =>
      put<ServerResult<dynamic>>('/user/nick', {
        "token": token,
        "use_push_on_area": info.usePushOnArea,
        "use_only_holiday_on_area": info.useOnlyHolidayOnArea,
        "use_only_in_month_on_area": info.useOnlyInMonthOnArea,
        "use_push_on_site": info.usePushOnSite,
        "use_only_holiday_on_site": info.useOnlyHolidayOnSite,
        "use_only_in_month_on_site": info.useOnlyInMonthOnSite,
        "reservation_day_push": info.reservationDayPush
      }).timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  Future<Response<ServerResult<dynamic>>> putUserArea(
          String token, int areaBit) =>
      put<ServerResult<dynamic>>('/user', {"token": token, "area_bit": areaBit})
          .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  Future<Response<ServerResult<dynamic>>> postUserFavoriteList(
          String token, String campId) =>
      post<ServerResult<dynamic>>('/user/favorite', {
        "token": token,
        "camp_id": campId,
      }).timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  Future<Response<ServerResult<dynamic>>> deleteUserFavoriteList(
          String token, String campId) =>
      delete<ServerResult<dynamic>>('/user/favorite/$token?camp_id=$campId')
          .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  Future<Response<ServerResult<dynamic>>> signOutUser(String token) =>
      delete<ServerResult<dynamic>>('/user/$token')
          .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);
}
