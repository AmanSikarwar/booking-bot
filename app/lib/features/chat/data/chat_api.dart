import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../../core/config.dart';
import '../../../core/net/sse.dart';
import '../domain/chat_event.dart';
import 'session.dart';

class ChatRequest {
  const ChatRequest({
    required this.conversationId,
    required this.clientMessageId,
    required this.kind,
    required this.locale,
    required this.text,
    required this.createdAt,
  });

  final String conversationId;
  final String clientMessageId;
  final String kind;
  final String locale;
  final String text;
  final DateTime createdAt;

  Map<String, Object?> toJson() => {
    'conversation_id': conversationId,
    'client_message_id': clientMessageId,
    'kind': kind,
    'locale': locale,
    'text': text,
    'client_created_at': createdAt.toUtc().toIso8601String(),
  };
}

class ChatApiException implements Exception {
  const ChatApiException(this.status, this.code, {this.retryable = false});

  final int status;
  final String code;
  final bool retryable;

  @override
  String toString() => 'ChatApiException($status, $code)';
}

@lazySingleton
class ChatApi {
  ChatApi(this._client, this._config, this._session);

  static const idleTimeout = Duration(seconds: 45);

  final http.Client _client;
  final AppConfig _config;
  final SessionTokens _session;

  Stream<ChatEvent> send(ChatRequest request) async* {
    var res = await _post(request, await _session.accessToken());
    if (res.statusCode == 401) {
      await res.stream.drain<void>();
      res = await _post(request, await _session.accessToken(refresh: true));
    }
    if (res.statusCode != 200) {
      final body = await res.stream.bytesToString();
      var code = 'http_${res.statusCode}';
      var retryable = res.statusCode >= 500 || res.statusCode == 409 || res.statusCode == 429;
      try {
        final json = jsonDecode(body) as Map<String, Object?>;
        code = json['code'] as String? ?? code;
        retryable = json['retryable'] as bool? ?? retryable;
      } on FormatException {
        // non-JSON error body from a proxy
      }
      throw ChatApiException(res.statusCode, code, retryable: retryable);
    }
    await for (final m in parseSse(res.stream.timeout(idleTimeout))) {
      yield ChatEvent.parse(m.event, m.data);
    }
  }

  Future<http.StreamedResponse> _post(ChatRequest request, String token) {
    final req = http.Request('POST', _config.chatUri)
      ..headers.addAll({
        'apikey': _config.publishableKey,
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'text/event-stream',
      })
      ..body = jsonEncode(request.toJson());
    return _client.send(req).timeout(const Duration(seconds: 20));
  }

  Future<bool> ping() async {
    try {
      final req = http.Request('GET', _config.healthUri)
        ..headers['apikey'] = _config.publishableKey;
      final res = await _client.send(req).timeout(const Duration(seconds: 8));
      await res.stream.drain<void>();
      return true;
    } on Object {
      return false;
    }
  }
}
