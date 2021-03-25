class ServerResult<DataType> {
  final bool result;
  final String msg;
  final DataType data;

  ServerResult(this.result, this.msg, this.data);

  ServerResult.fromMap(Map<String, dynamic> json)
      : result = json['result'] ?? false,
        msg = json['msg'],
        data = json['data'] as DataType;

  static ServerResult<DataType> fromJson<DataType>(jsonStr) {
    final maps = Map<String, dynamic>.from(jsonStr);
    final result = ServerResult<DataType>.fromMap(maps);

    return result;
  }
}
