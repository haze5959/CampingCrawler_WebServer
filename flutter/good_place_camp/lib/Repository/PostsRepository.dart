import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

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
          int id, String pw) =>
      get('/post/$id?key=$pw');

  Future<Response<ServerResult<dynamic>>> postPostsWith(Post post) =>
      post('/report', {id: id, body: body});

  Future<Response<ServerResult<dynamic>>> postReportWith(
          String id, String body) =>
      post('/report', {id: id, body: body});
}
