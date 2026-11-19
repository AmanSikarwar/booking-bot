import 'dart:convert';

typedef SseMessage = ({String event, Map<String, Object?> data});

Stream<SseMessage> parseSse(Stream<List<int>> bytes) async* {
  var event = 'message';
  final data = <String>[];
  await for (final line in bytes.transform(utf8.decoder).transform(const LineSplitter())) {
    if (line.isEmpty) {
      if (data.isNotEmpty) {
        final decoded = _tryDecode(data.join('\n'));
        if (decoded != null) yield (event: event, data: decoded);
      }
      event = 'message';
      data.clear();
    } else if (line.startsWith(':')) {
      continue;
    } else if (line.startsWith('event:')) {
      event = line.substring(6).trim();
    } else if (line.startsWith('data:')) {
      data.add(line.substring(5).replaceFirst(RegExp('^ '), ''));
    }
  }
}

Map<String, Object?>? _tryDecode(String raw) {
  try {
    final v = jsonDecode(raw);
    return v is Map<String, Object?> ? v : null;
  } on FormatException {
    return null;
  }
}
