import 'package:get/get.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostListContoller extends GetxController {
  final bool isNotice;
  int pageNum = 1;

  PostListContoller({required this.isNotice});

  RxList<Post> postList = RxList<Post>.empty();

  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;

  void fetchPosts({bool reset = false}) async {
    if (reset) {
      pageNum = 1;
      postList.clear();
      isLastPage.value = false;
    }

    if (!isLastPage.value) {
      isLoading.value = true;

      final res = await ApiRepo.posts.getAllPostsSimpleList(pageNum, isNotice);
      if (!res.result) {
        showServerErrorAlert(res.msg, true);
        return;
      }
      
      final data = res.data!;
      if (data.length == 0) {
        isLastPage.value = true;
      } else {
        postList.addAll(data);
        pageNum += 1;
      }

      isLoading.value = false;
    }
  }
}
