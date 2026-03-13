import 'dart:convert';

/// Parses an SSE (Server-Sent Events) byte stream and yields each `data:` line.
///
/// - Keeps payload as-is (does not trim), preserving spaces/emoji.
/// - Tolerates UTF-8 BOM and unexpected leading whitespace before `data:`.
Stream<String> sseDataLines(Stream<List<int>> byteStream) async* {
  final decoder = const Utf8Decoder(allowMalformed: true);
  var buffer = '';

  await for (final chunk in byteStream) {
    buffer += decoder.convert(chunk);

    while (true) {
      final nl = buffer.indexOf('\n');
      if (nl < 0) break;

      var line = buffer.substring(0, nl);
      buffer = buffer.substring(nl + 1);

      if (line.endsWith('\r')) line = line.substring(0, line.length - 1);
      if (line.isEmpty) continue;
      if (line.startsWith('\ufeff')) line = line.substring(1);

      final trimmedLeft = line.trimLeft();
      if (!trimmedLeft.startsWith('data:')) continue;

      // Keep original payload (without trimming) by slicing after the first `data:`.
      final dataIndex = line.indexOf('data:');
      if (dataIndex < 0) continue;
      yield line.substring(dataIndex + 'data:'.length);
    }
  }

  // Handle any trailing last line without newline.
  var tail = buffer;
  if (tail.endsWith('\r')) tail = tail.substring(0, tail.length - 1);
  if (tail.startsWith('\ufeff')) tail = tail.substring(1);
  final trimmedLeft = tail.trimLeft();
  if (trimmedLeft.startsWith('data:')) {
    final dataIndex = tail.indexOf('data:');
    if (dataIndex >= 0) {
      yield tail.substring(dataIndex + 'data:'.length);
    }
  }
}

