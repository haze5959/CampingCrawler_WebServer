import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostsRepository extends GetConnect {
  @override
  PostsRepository() {
    httpClient.baseUrl = 'http://haze5959.iptime.org:8000';
  }

  Future<Response<Map<String, List<Post>>>> getFirstPagePostsList() {
    get('/home', decoder: Post.fromJsonToHomePosts).then((result) => {

    }).timeout(timeOutSec);
  }

  Future<Response<List<Post>>> getAllPostsSimpleList(
      int page, List<PostType> typeList) {
    var url = '/post/list/$page';
    Iterable<int>.generate(typeList.length).forEach((index) => {
          if (index == 0)
            url += "?type=${toInt(typeList[index])}"
          else
            url += "&type=${toInt(typeList[index])}"
        });

    return get(url, decoder: Post.fromJsonArr);
  }

  Future<Response<Board>> getPostsWith(int id) =>
      get('/post/$id', decoder: Board.fromJson);

  Future<Response<Board>> getSecretPostsWith(int id, String pw) =>
      get('/post/$id?key=$pw', decoder: Board.fromJson);
}
