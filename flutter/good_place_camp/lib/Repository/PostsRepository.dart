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

  // Future<Response<ServerResult<dynamic>>> getAllPostsSimpleList(
  //     int page, List<PostType> typeList) {
  //   var url = '/post/list/$page';
  //   Iterable<int>.generate(typeList.length).forEach((index) => {
  //         if (index == 0)
  //           url += "?type=${toInt(typeList[index])}"
  //         else
  //           url += "&type=${toInt(typeList[index])}"
  //       });

  //   return get<ServerResult<dynamic>>(url)
  //       .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);
  // }

  // Future<Response<ServerResult<dynamic>>> getPostsWith(int id) =>
  //     get<ServerResult<dynamic>>('/post/$id')
  //         .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  // Future<Response<ServerResult<dynamic>>> getSecretPostsWith(
  //         int id, String token) =>
  //     get<ServerResult<dynamic>>('/post/$id?token=$token')
  //         .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  // Future<Response<ServerResult<dynamic>>> postPostsWith(
  //         int type, String title, String body, String token) =>
  //     post<ServerResult<dynamic>>('/post', {
  //       "type": type,
  //       "title": title,
  //       "body": body,
  //       "token": token
  //     }).timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  // Future<Response<ServerResult<dynamic>>> postCommentWith(
  //         int postId, String nick, String comment, String token) =>
  //     post<ServerResult<dynamic>>('/comment', {
  //       "post_id": postId,
  //       "nick": nick,
  //       "comment": comment,
  //       "token": token
  //     }).timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  // Future<Response<ServerResult<dynamic>>> postReportWith(
  //         String id, String body) =>
  //     post<ServerResult<dynamic>>('/report', {"id": id, "body": body})
  //         .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  // Future<Response<ServerResult<dynamic>>> deletePosts(String token, int id) =>
  //     delete<ServerResult<dynamic>>('/post/$token?id=$id')
  //         .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);

  // Future<Response<ServerResult<dynamic>>> deleteComment(String token, int id, int postId) =>
  //     delete<ServerResult<dynamic>>('/comment/$token?id=$id&post_id=$postId')
  //         .timeout(TIMEOUT_SEC, onTimeout: timeoutResponse);
}
