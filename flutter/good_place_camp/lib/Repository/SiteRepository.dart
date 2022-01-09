import 'package:good_place_camp/Constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

// Model
import 'package:good_place_camp/Model/ServerResult.dart';
import 'package:good_place_camp/Model/SiteInfo.dart';
import 'package:good_place_camp/Model/CampInfo.dart';
import 'package:good_place_camp/Model/HomeInfo.dart';

part 'SiteRepository.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class SiteRepository {
  factory SiteRepository(Dio dio, {String baseUrl}) = _SiteRepository;

  @GET("/home")
  Future<ServerResult<HomeInfo>> getHomeInfo(@Query("area_bit") int areaBit);

  @GET("/camp/{site}")
  Future<ServerResult<SiteDetailInfo>> getSiteInfo(@Path() String site);

  @GET("/camp")
  Future<ServerResult<SiteListInfo>> getSiteInfoWithArea(@Query("area_bit") int areaBit);

  @GET("/info")
  Future<ServerResult<CampData>> getAllSiteJson();
}
