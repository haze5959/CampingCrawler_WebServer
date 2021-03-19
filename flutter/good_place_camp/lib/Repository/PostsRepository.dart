import 'package:get/get.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostsRepository extends GetConnect {
  @override
  PostsRepository() {
    httpClient.baseUrl = 'http://haze5959.iptime.org:8000';
  }

  Future<Response<List<Post>>> getAllPostsSimpleList(int page) =>
      get('/post/list/$page', decoder: Post.fromJsonArr);

  Future<Response<Board>> getPostsWith(int id) =>
      get('/post/$id', decoder: Board.fromJson);

  Future<Response<Board>> getSecretPostsWith(int id, String pw) =>
      get('/post/$id?key=$pw', decoder: Board.fromJson);
}
