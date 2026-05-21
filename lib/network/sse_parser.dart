import 'dart:convert';

/// SSE（Server-Sent Events）数据流解析器。
///
/// 解析 SSE 字节流并生成每个 `data:` 行的内容。
///
/// 特性：
/// - 保持原始内容格式（不修剪），保留空格和表情符号
/// - 容忍 UTF-8 BOM 和 `data:` 前的意外空白
/// - 支持没有换行符的最后一行
///
/// 使用示例：
/// ```dart
/// await for (final line in sseDataLines(responseStream)) {
///   print(line); // 每个 `data:` 后的内容
/// }
/// ```
Stream<String> sseDataLines(Stream<List<int>> byteStream) async* {
  /// UTF-8 解码器，允许格式错误的 UTF-8
  final decoder = const Utf8Decoder(allowMalformed: true);

  /// 缓冲区，用于存储未处理的文本
  var buffer = '';

  /// 遍历字节流
  await for (final chunk in byteStream) {
    /// 将字节块解码为文本并追加到缓冲区
    buffer += decoder.convert(chunk);

    /// 循环处理缓冲区中的完整行
    while (true) {
      /// 查找换行符位置
      final nl = buffer.indexOf('\n');
      if (nl < 0) break;

      /// 提取一行
      var line = buffer.substring(0, nl);

      /// 移除已处理的行
      buffer = buffer.substring(nl + 1);

      /// 移除行尾的回车符
      if (line.endsWith('\r')) line = line.substring(0, line.length - 1);

      /// 跳过空行
      if (line.isEmpty) continue;

      /// 移除 UTF-8 BOM
      if (line.startsWith('\ufeff')) line = line.substring(1);

      /// 检查是否为 `data:` 行（忽略前导空白）
      final trimmedLeft = line.trimLeft();
      if (!trimmedLeft.startsWith('data:')) continue;

      /// 找到 `data:` 的位置，返回其后的内容（保持原始格式）
      final dataIndex = line.indexOf('data:');
      if (dataIndex < 0) continue;
      yield line.substring(dataIndex + 'data:'.length);
    }
  }

  /// 处理缓冲区中剩余的最后一行（没有换行符的情况）
  var tail = buffer;

  /// 移除行尾的回车符
  if (tail.endsWith('\r')) tail = tail.substring(0, tail.length - 1);

  /// 移除 UTF-8 BOM
  if (tail.startsWith('\ufeff')) tail = tail.substring(1);

  /// 检查是否为 `data:` 行
  final trimmedLeft = tail.trimLeft();
  if (trimmedLeft.startsWith('data:')) {
    final dataIndex = tail.indexOf('data:');
    if (dataIndex >= 0) {
      yield tail.substring(dataIndex + 'data:'.length);
    }
  }
}
