import 'dart:math';

import 'package:injectable/injectable.dart';

@lazySingleton
class AppConfig {
  final String supabaseUrl = const String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://lscqahnqffcukyegjvpk.supabase.co',
  );
  final String publishableKey = const String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_fYpoT2raUr0QSOYkKn9DrQ_vue8vlM-',
  );

  Uri get chatUri => Uri.parse('$supabaseUrl/functions/v1/chat');
}

@lazySingleton
class Clock {
  final _random = Random();

  DateTime now() => DateTime.now();

  double jitter() => 0.8 + _random.nextDouble() * 0.4;
}
