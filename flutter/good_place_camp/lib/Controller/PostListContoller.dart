import 'package:get/get.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Repository
import 'package:good_place_camp/Repository/PostsRepository.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostListContoller extends GetxController {
  final bool isNotice;
  List<PostType> typeList;
  int pageNum = 0;

  PostListContoller({this.isNotice}) {
    if (isNotice) {
      typeList = [PostType.notice];
    } else {
      typeList = [PostType.question, PostType.request, PostType.secret];
    }
  }

  final PostsRepository repo = PostsRepository();

  RxList<Post> postList = RxList<Post>.empty();

  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;

  void fetchPosts({bool reset = false}) async {
    if (!isLastPage.value) {
      isLoading.value = true;

      final result = await repo.getAllPostsSimpleList(pageNum, typeList);
      if (result.hasError) {
        showOneBtnAlert(Get.context, result.statusText, "재시도", fetchPosts);
        return;
      } else if (!result.body.result) {
        showOneBtnAlert(Get.context, result.body.msg, "재시도", fetchPosts);
        return;
      }

      final postListData = Post.fromJsonArr(result.body.data);
      if (postListData.length == 0) {
        isLastPage.value = true;
      } else {
        if (reset) {
          postList.assignAll(postListData);
          pageNum = 1;
        } else {
          postList.addAll(postListData);
          pageNum += 1;
        }
      }

      isLoading.value = false;
    }
  }
}
