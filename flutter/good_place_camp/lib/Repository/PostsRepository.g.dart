// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostsRepository.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _PostsRepository implements PostsRepository {
  _PostsRepository(this._dio, {this.baseUrl}) {
    baseUrl ??= 'http://haze5959.iptime.org:8000';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServerResult<HomeInfo>> getHomeInfo() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServerResult<HomeInfo>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/home',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServerResult<HomeInfo>.fromJson(
      _result.data!,
      (json) => HomeInfo.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServerResult<List<Post>>> getAllPostsSimpleList(page, isNotice) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'is_notice': isNotice};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServerResult<List<Post>>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/post/list/$page',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServerResult<List<Post>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<Post>((i) => Post.fromJson(i as Map<String, dynamic>))
            .toList());
    return value;
  }

  @override
  Future<ServerResult<Board>> getPosts(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServerResult<Board>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/post/$id',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServerResult<Board>.fromJson(
      _result.data!,
      (json) => Board.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServerResult<Board>> getSecretPosts(id, token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'token': token};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServerResult<Board>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/post/$id',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServerResult<Board>.fromJson(
      _result.data!,
      (json) => Board.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServerResult<dynamic>> createPosts(posts, token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'posts': posts, 'token': token};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServerResult<dynamic>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/post',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServerResult<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<ServerResult<dynamic>> createComment(commnet, token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'commnet': commnet, 'token': token};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServerResult<dynamic>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/post',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServerResult<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<ServerResult<dynamic>> createReport(id, token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'id': id, 'token': token};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServerResult<dynamic>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/report',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServerResult<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<ServerResult<dynamic>> deletePosts(id, token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'token': token};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServerResult<dynamic>>(
            Options(method: 'DELETE', headers: _headers, extra: _extra)
                .compose(_dio.options, '/post/$id',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServerResult<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<ServerResult<dynamic>> deleteComment(id, token, postId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'token': token,
      r'post_id': postId
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServerResult<dynamic>>(
            Options(method: 'DELETE', headers: _headers, extra: _extra)
                .compose(_dio.options, '/comment/$id',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServerResult<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
