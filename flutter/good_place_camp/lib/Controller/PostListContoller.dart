import 'package:get/get.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:good_place_camp/Repository/ApiRepository.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostListContoller extends GetxController {
  final bool isNotice;
  final List<PostType> typeList;
  int pageNum = 0;

  PostListContoller._(this.isNotice, this.typeList);

  factory PostListContoller(bool isNotice) {
    if (isNotice) {
      return PostListContoller._(isNotice, [PostType.notice]);
    } else {
      return PostListContoller._(
          isNotice, [PostType.question, PostType.request, PostType.secret]);
    }
  }

  RxList<Post> postList = RxList<Post>.empty();

  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;

  void fetchPosts({bool reset = false}) async {
    if (reset) {
      pageNum = 0;
      postList.clear();
      isLastPage.value = false;
    }

    if (!isLastPage.value) {
      isLoading.value = true;

      final res = await ApiRepo.posts.getAllPostsSimpleList(pageNum, typeList);
      final data = res.data;
      if (!res.result) {
        showOneBtnAlert(res.msg, "확인", () {});
        return;
      } else if (data == null) {
        print("reloadInfo result fail - " + res.msg);
        showOneBtnAlert("서버가 불안정 합니다. 잠시 후 다시 시도해주세요.", "확인", () {});
        return;
      }

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
