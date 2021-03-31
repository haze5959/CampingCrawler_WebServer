class ServerResult<DataType> {
  final bool result;
  final String msg;
  final DataType data;

  ServerResult(this.result, this.msg, this.data);

  ServerResult.fromMap(Map<String, dynamic> json)
      : result = json['result'] ?? false,
        msg = json['msg'] is String ?  json['msg'] : "서버가 불안정합니다. 잠시 후에 다시 시도해주세요.",
        data = json['data'] as DataType;

  static ServerResult<DataType> fromJson<DataType>(jsonStr) {
    final maps = Map<String, dynamic>.from(jsonStr);
    final result = ServerResult<DataType>.fromMap(maps);

    return result;
  }
}
