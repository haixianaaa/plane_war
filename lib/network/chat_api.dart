import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_application_2/network/sse_parser.dart';

import 'api_client.dart';

/// 聊天 API 类。
///
/// 提供聊天相关的 API 接口，支持流式响应（SSE）。
/// 针对移动端和 Web 端做了不同的流式处理适配。
class ChatApi {
  /// 创建聊天 API 实例。
  ///
  /// [_api] API 客户端实例
  ChatApi(this._api);

  /// API 客户端实例
  final ApiClient _api;

  /// 发送聊天消息并获取流式响应。
  ///
  /// POST `/chat/send` 并返回 SSE `data:` 行的流。
  ///
  /// 平台适配：
  /// - Web: 使用普通文本响应，完成后解析 `data:` 行
  /// - 移动端: 使用真正的流式响应
  ///
  /// [payload] 请求体，包含消息内容和模型参数
  /// [cancelToken] 可选的取消令牌，用于取消请求
  ///
  /// 返回 SSE 数据行的流
  Stream<String> sendStream({
    required Map<String, dynamic> payload,
    CancelToken? cancelToken,
  }) async* {
    /// Web 平台：Dio Web 适配器不支持真正的流式响应
    /// 使用普通文本响应，完成后解析 `data:` 行
    if (kIsWeb) {
      /// 发送请求，获取完整响应
      final res = await _api.dio.post<String>(
        '/chat/send',
        data: payload,
        options: Options(
          responseType: ResponseType.plain,
          headers: const {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
          },
          receiveTimeout: null,
        ),
        cancelToken: cancelToken,
      );

      /// 解析响应文本中的每一行
      final text = res.data ?? '';
      for (final line in text.split(RegExp(r'\r?\n'))) {
        var l = line;

        /// 移除 UTF-8 BOM
        if (l.startsWith('\ufeff')) l = l.substring(1);

        /// 只处理 `data:` 开头的行
        if (!l.startsWith('data:')) continue;

        /// 返回 `data:` 后的内容
        yield l.substring('data:'.length);
      }
      return;
    }

    /// 移动端：尝试使用真正的流式响应
    try {
      /// 发送流式请求
      final res = await _api.dio.post<ResponseBody>(
        '/chat/send',
        data: payload,
        options: Options(
          responseType: ResponseType.stream,
          headers: const {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
          },
          /// 流式请求不设置接收超时
          receiveTimeout: null,
        ),
        cancelToken: cancelToken,
      );

      final body = res.data;
      if (body == null) return;

      /// 使用 SSE 解析器解析流
      yield* sseDataLines(body.stream);
      return;
    } catch (_) {
      /// 降级处理：如果流式响应不支持，回退到普通文本响应
      final res = await _api.dio.post<String>(
        '/chat/send',
        data: payload,
        options: Options(
          responseType: ResponseType.plain,
          headers: const {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
          },
          receiveTimeout: null,
        ),
        cancelToken: cancelToken,
      );

      /// 解析响应文本
      final text = res.data ?? '';
      for (final line in text.split(RegExp(r'\r?\n'))) {
        var l = line;

        /// 移除 UTF-8 BOM
        if (l.startsWith('\ufeff')) l = l.substring(1);

        /// 只处理 `data:` 开头的行
        if (!l.startsWith('data:')) continue;

        /// 返回 `data:` 后的内容
        yield l.substring('data:'.length);
      }
    }
  }
}
