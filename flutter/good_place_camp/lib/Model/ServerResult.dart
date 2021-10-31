import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ServerResult<DataType> {
  bool result;
  String msg;
  DataType data;

  ServerResult({this.result, this.msg, this.data});

  factory ServerResult.fromJson(Map<String, dynamic> json) => _$ServerResultFromJson(json);
  Map<String, dynamic> toJson() => _$ServerResultToJson(this);
  // ServerResult.fromMap(Map<String, dynamic> json)
  //     : result = json['result'] ?? false,
  //       msg = json['msg'] is String ?  json['msg'] : "서버가 불안정합니다. 잠시 후에 다시 시도해주세요.",
  //       data = json['data'] as DataType;

  // static ServerResult<DataType> fromJson<DataType>(jsonStr) {
  //   final maps = Map<String, dynamic>.from(jsonStr);
  //   final result = ServerResult<DataType>.fromMap(maps);

  //   return result;
  // }
}
