// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ServerResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerResult<DataType> _$ServerResultFromJson<DataType>(
  Map<String, dynamic> json,
  DataType Function(Object? json) fromJsonDataType,
) {
  print("OQOQOQOQQO");
  print(json);
  print(fromJsonDataType);
    return ServerResult<DataType>(
      result: json['result'] as bool,
      msg: json['msg'] as String,
      data: _$nullableGenericFromJson(json['data'], fromJsonDataType),
    );
}

Map<String, dynamic> _$ServerResultToJson<DataType>(
  ServerResult<DataType> instance,
  Object? Function(DataType value) toJsonDataType,
) =>
    <String, dynamic>{
      'result': instance.result,
      'msg': instance.msg,
      'data': _$nullableGenericToJson(instance.data, toJsonDataType),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
