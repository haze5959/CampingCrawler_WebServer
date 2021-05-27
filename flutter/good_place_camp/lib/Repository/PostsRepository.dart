import 'package:get/get.dart';

// Model
import 'package:good_place_camp/Model/ServerResult.dart';
import 'package:good_place_camp/Model/Post.dart';

class PostsRepository extends GetConnect {
  @override
  PostsRepository() {
    httpClient.defaultDecoder = ServerResult.fromJson;
    httpClient.baseUrl = 'http://haze5959.iptime.org:8000';
  }

  Future<Response<ServerResult<dynamic>>> getFirstPagePostsList() {
    return get('/home');
  }

  Future<Response<ServerResult<dynamic>>> getAllPostsSimpleList(
      int page, List<PostType> typeList) {
    var url = '/post/list/$page';
    Iterable<int>.generate(typeList.length).forEach((index) => {
          if (index == 0)
            url += "?type=${toInt(typeList[index])}"
          else
            url += "&type=${toInt(typeList[index])}"
        });

    return get(url);
  }

  Future<Response<ServerResult<dynamic>>> getPostsWith(int id) =>
      get('/post/$id');

  Future<Response<ServerResult<dynamic>>> getSecretPostsWith(
          int id, String token) =>
      get('/post/$id?token=$token');

  Future<Response<ServerResult<dynamic>>> postPostsWith(
          int type, String title, String body, String token) =>
      post('/post', {
        "type": type,
        "title": title,
        "body": body,
        "token": token
      });

  Future<Response<ServerResult<dynamic>>> postCommentWith(
          int postId, String nick, String comment, String token) =>
      post('/comment', {"post_id": postId, "nick": nick, "comment": comment, "token": token});

  Future<Response<ServerResult<dynamic>>> postReportWith(
          String id, String body) =>
      post('/report', {"id": id, "body": body});
}
