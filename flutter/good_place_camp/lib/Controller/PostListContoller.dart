import 'package:get/get.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';

// Repository
import 'package:good_place_camp/Repository/PostsRepository.dart';

// Model
import 'package:good_place_camp/Model/Post.dart';

class PostListContoller extends GetxController {
  final bool isNotice; 
  List<PostType> typeList;

  PostListContoller({this.isNotice}) {
    if (isNotice) {
      typeList = [PostType.notice];
    } else {
      typeList = [PostType.question, PostType.request, PostType.secret];
    }

    reload();
  }

  PostsRepository repo = PostsRepository();

  RxList<Post> postList = RxList<Post>.empty();
  
  RxBool isLoading = false.obs;

  void reload() async {
    isLoading.value = true;

    final result = await repo.getAllPostsSimpleList(0, typeList);
    if (result.hasError) {
      showOneBtnAlert(Get.context, result.statusText, "재시도", reload);
      return;
    } else if (!result.body.result) {
      showOneBtnAlert(Get.context, result.body.msg, "재시도", reload);
      return;
    }

    final postListData = Post.fromJsonArr(result.body.data);
    postList.assignAll(postListData);

    isLoading.value = false;
  }
}
