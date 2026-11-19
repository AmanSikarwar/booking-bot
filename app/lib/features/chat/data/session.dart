import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SessionTokens {
  Future<String> accessToken({bool refresh = false});
}

@LazySingleton(as: SessionTokens)
class SupabaseSessionTokens implements SessionTokens {
  SupabaseSessionTokens(this._client);

  final SupabaseClient _client;

  @override
  Future<String> accessToken({bool refresh = false}) async {
    final auth = _client.auth;
    if (auth.currentSession == null) {
      await auth.signInAnonymously();
    } else if (refresh || auth.currentSession!.isExpired) {
      await auth.refreshSession();
    }
    return auth.currentSession!.accessToken;
  }
}
