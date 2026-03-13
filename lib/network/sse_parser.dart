import 'dart:convert';

/// Parses an SSE (Server-Sent Events) byte stream and yields each `data:` line.
///
/// Backend example:
///   data:hello
///   data: world
///
/// Each `data:` line is yielded as-is (without trimming), preserving spaces/emoji.
Stream<String> sseDataLines(Stream<List<int>> byteStream) async* {
  final lines = byteStream.transform(utf8.decoder).transform(const LineSplitter());
  await for (final line in lines) {
    var l = line;
    // Some servers may prepend UTF-8 BOM on the first line.
    if (l.startsWith('\ufeff')) {
      l = l.substring(1);
    }
    // Keep only `data:` lines; do not trim payload.
    if (!l.startsWith('data:')) continue;
    yield l.substring('data:'.length);
  }
}

