import 'package:good_place_camp/Constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

// Model
import 'package:good_place_camp/Model/ServerResult.dart';
import 'package:good_place_camp/Model/PushInfo.dart';
import 'package:good_place_camp/Model/CampUser.dart';

part 'UserRepository.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  // 만약 해당 토큰에 관한 유저정보가 없다면 새로 만든다.
  @GET("/user")
  Future<ServerResult<CampUserInfo>> getUserInfo(@Query("token") String token);

  @GET("/user/favorite")
  Future<ServerResult<List<String>>> getUserFavoriteList(@Query("token") String token);

  @GET("/user/push")
  Future<ServerResult<PushInfo>> getUserPushInfo(@Query("token") String token);

  @PUT("/user/nick")
  Future<ServerResult> putUserNick(
    @Field() String token,
    @Field() String nick);

  @PUT("/user/push")
  Future<ServerResult> putPushInfo(
    @Field() String token,
    @Field("push_info") PushInfo pushInfo);
  
  @PUT("/user")
  Future<ServerResult> putUserArea(
    @Field() String token,
    @Field("area_bit") int areaBit);

  @POST("/user/favorite")
  Future<ServerResult> postUserFavoriteList(
    @Field() String token,
    @Field() int campId);

  @DELETE("/user/favorite/{camp_id}")
  Future<ServerResult> deleteUserFavoriteList(
    @Path() String campId,
    @Query("token") String token);

  // sign out
  @DELETE("/user")
  Future<ServerResult> deleteUser(@Query("token") String token);
}
