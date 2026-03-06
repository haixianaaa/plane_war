/// Standard backend response: `{ code, msg, data }`.
class ApiResponse<T> {
  const ApiResponse({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int code;
  final String msg;
  final T? data;

  bool get isSuccess => code == 200;

  static ApiResponse<T> fromJson<T>(
    Map<String, dynamic> json, {
    T Function(Object? raw)? decoder,
  }) {
    final code = (json['code'] as num?)?.toInt() ?? -1;
    final msg = (json['msg'] as String?) ?? '';
    final raw = json['data'];
    final data = decoder == null ? raw as T? : decoder(raw);
    return ApiResponse<T>(code: code, msg: msg, data: data);
  }
}


