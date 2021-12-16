import 'package:dio/dio.dart';

// Repository
import 'package:good_place_camp/Repository/PostsRepository.dart';
import 'package:good_place_camp/Repository/SiteRepository.dart';
import 'package:good_place_camp/Repository/UserRepository.dart';

class ApiRepo {
  static final _dio =
      Dio(BaseOptions(connectTimeout: 10 * 1000, receiveTimeout: 10 * 1000));

  static final posts = PostsRepository(_dio);
  static final site = SiteRepository(_dio);
  static final user = UserRepository(_dio);
}

// retrofit 빌드 명령어
// flutter pub run build_runner build