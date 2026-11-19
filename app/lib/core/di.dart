import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../features/catalog/package.dart';
import '../features/safety/red_flag_detector.dart';
import '../gen/assets.gen.dart';
import 'db/database.dart';
import 'di.config.dart';
import 'net/http_client.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() => getIt.init();

@module
abstract class AppModule {
  @singleton
  AppDatabase get database => AppDatabase.defaults();

  @lazySingleton
  http.Client get httpClient => createHttpClient();

  @lazySingleton
  SupabaseClient get supabase => Supabase.instance.client;

  @lazySingleton
  Uuid get uuid => const Uuid();

  @preResolve
  Future<RedFlagDetector> get redFlagDetector async => RedFlagDetector(
    jsonDecode(await rootBundle.loadString(Assets.shared.redFlags)) as Map<String, Object?>,
  );

  @preResolve
  Future<Catalog> get catalog async => Catalog.fromJson(
    jsonDecode(await rootBundle.loadString(Assets.shared.packages)) as Map<String, Object?>,
  );
}
