/// 标准后端响应模型。
///
/// 后端统一响应格式：`{ code, msg, data }`
/// - code: 状态码，200 表示成功
/// - msg: 响应消息
/// - data: 响应数据
class ApiResponse<T> {
  /// 创建 API 响应实例。
  ///
  /// [code] 状态码，200 表示成功
  /// [msg] 响应消息
  /// [data] 响应数据，类型由泛型 T 指定
  const ApiResponse({
    required this.code,
    required this.msg,
    required this.data,
  });

  /// 状态码，200 表示请求成功
  final int code;

  /// 响应消息，描述请求结果
  final String msg;

  /// 响应数据，具体类型由泛型 T 决定
  final T? data;

  /// 判断请求是否成功。
  ///
  /// 返回 true 表示状态码为 200，请求成功
  bool get isSuccess => code == 200;

  /// 从 JSON 创建 ApiResponse 实例。
  ///
  /// [json] 原始 JSON 数据
  /// [decoder] 可选的数据解码器，用于将原始数据转换为目标类型
  ///
  /// 返回解析后的 ApiResponse 实例
  static ApiResponse<T> fromJson<T>(
    Map<String, dynamic> json, {
    T Function(Object? raw)? decoder,
  }) {
    /// 解析状态码，默认为 -1
    final code = (json['code'] as num?)?.toInt() ?? -1;

    /// 解析消息，默认为空字符串
    final msg = (json['msg'] as String?) ?? '';

    /// 获取原始数据
    final raw = json['data'];

    /// 如果提供了解码器，使用解码器转换数据；否则直接使用原始数据
    final data = decoder == null ? raw as T? : decoder(raw);

    return ApiResponse<T>(code: code, msg: msg, data: data);
  }
}
