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
