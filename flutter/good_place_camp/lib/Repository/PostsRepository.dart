import 'package:get/get.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostsRepository extends GetConnect {
  @override
  PostsRepository() {
    // httpClient.defaultDecoder = SiteInfo.fromJsonArr;
    httpClient.baseUrl = 'http://haze5959.iptime.org:8000';
  }

  Future<Response<List<Post>>> getAllPostsSimpleList() =>
      get('/posts', decoder: Post.fromJsonArr);

  Future<Response<Post>> getPostsWith(int id) =>
      get('/posts/$id', decoder: Post.fromJson);

  Future<Response<List<Comment>>> getCommentWith(int id) =>
      get('/comment/$id', decoder: Comment.fromJsonArr);
}
