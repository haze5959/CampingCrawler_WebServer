import 'package:good_place_camp/Constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

// Model
import 'package:good_place_camp/Model/ServerResult.dart';
import 'package:good_place_camp/Model/Post.dart';

part 'PostsRepository.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class PostsRepository {
  factory PostsRepository(Dio dio, {String baseUrl}) = _PostsRepository;

  @GET("/home")
  Future<ServerResult<HomeInfo>> getHomeInfo();

  @GET("/post/list/{page}")
  Future<ServerResult<List<Post>>> getAllPostsSimpleList(
    @Path() String page,
    @Query("url") List<PostType> typeList);

  @GET("/post/{id}")
  Future<ServerResult<Post>> getPosts(@Path() int id);

  @GET("/post/{id}")
  Future<ServerResult<Post>> getSecretPosts(
    @Path() int id,
    @Query("token") String token);

  @POST("/post")
  Future<ServerResult> createPosts(
    @Field() Post posts,
    @Field() String token);

  @POST("/post")
  Future<ServerResult> createComment(
    @Field() Comment commnet,
    @Field() String token);

  @POST("/report")
  Future<ServerResult> createReport(
    @Field() String id,
    @Field() String token);

  @DELETE("/post/{id}")
  Future<ServerResult> deletePosts(
    @Path() int id,
    @Query("token") String token);

  @DELETE("/comment/{id}")
  Future<ServerResult> deleteComment(
    @Path() int id,
    @Query("token") String token,
    @Query("post_id") String postId);
}
