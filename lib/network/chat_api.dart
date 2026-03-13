import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_application_2/network/sse_parser.dart';

import 'api_client.dart';

class ChatApi {
  ChatApi(this._api);

  final ApiClient _api;

  /// POST `/chat/send` with `stream:true` and return SSE `data:` lines.
  Stream<String> sendStream({
    required Map<String, dynamic> payload,
    CancelToken? cancelToken,
  }) async* {
    // Dio web adapter doesn't support true streaming reliably.
    // Use plain text response and parse `data:` lines after completion.
    if (kIsWeb) {
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

      final text = res.data ?? '';
      for (final line in text.split(RegExp(r'\r?\n'))) {
        var l = line;
        if (l.startsWith('\ufeff')) l = l.substring(1);
        if (!l.startsWith('data:')) continue;
        yield l.substring('data:'.length);
      }
      return;
    }

    try {
      final res = await _api.dio.post<ResponseBody>(
        '/chat/send',
        data: payload,
        options: Options(
          responseType: ResponseType.stream,
          headers: const {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
          },
          // streaming: don't use receiveTimeout
          receiveTimeout: null,
        ),
        cancelToken: cancelToken,
      );

      final body = res.data;
      if (body == null) return;
      yield* sseDataLines(body.stream);
      return;
    } catch (_) {
      // Fallback for platforms where streaming isn't supported (e.g. some web adapters):
      // fetch the full response as text then parse `data:` lines.
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

      final text = res.data ?? '';
      for (final line in text.split(RegExp(r'\r?\n'))) {
        var l = line;
        if (l.startsWith('\ufeff')) l = l.substring(1);
        if (!l.startsWith('data:')) continue;
        yield l.substring('data:'.length);
      }
    }
  }
}

