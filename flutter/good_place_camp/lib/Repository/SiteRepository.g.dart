// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SiteRepository.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _SiteRepository implements SiteRepository {
  _SiteRepository(this._dio, {this.baseUrl}) {
    baseUrl ??= 'http://haze5959.iptime.org:8000';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ServerResult<SiteDateInfo>> getSiteInfo(site) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServerResult<SiteDateInfo>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/camp/$site',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServerResult<SiteDateInfo>.fromJson(
      _result.data!,
      (json) => SiteDateInfo.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<ServerResult<List<SiteDateInfo>>> getSiteInfoWithArea(areaList) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'area_bit': areaList};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServerResult<List<SiteDateInfo>>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/camp',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServerResult<List<SiteDateInfo>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<SiteDateInfo>(
                (i) => SiteDateInfo.fromJson(i as Map<String, dynamic>))
            .toList());
    return value;
  }

  @override
  Future<ServerResult<List<CampSimpleInfo>>> getAllSiteJson() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServerResult<List<CampSimpleInfo>>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/info',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServerResult<List<CampSimpleInfo>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<CampSimpleInfo>(
                (i) => CampSimpleInfo.fromJson(i as Map<String, dynamic>))
            .toList());
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
