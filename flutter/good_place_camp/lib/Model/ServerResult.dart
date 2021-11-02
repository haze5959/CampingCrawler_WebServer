import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(genericArgumentFactories: true)
class ServerResult<DataType> {
  final bool result;
  final String msg;
  final DataType? data;

  ServerResult({
    required this.result, 
    required this.msg, 
    this.data
    });

  factory ServerResult.fromJson(Map<String, dynamic> json, DataType Function(Object? json) fromJsonT) => _$ServerResultFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object? Function(DataType value) toJsonT) => _$ServerResultToJson(this, toJsonT);
}
