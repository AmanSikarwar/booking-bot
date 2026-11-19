// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:saathi/core/config.dart' as _i961;
import 'package:saathi/core/connectivity/connectivity_service.dart' as _i370;
import 'package:saathi/core/db/database.dart' as _i537;
import 'package:saathi/core/di.dart' as _i800;
import 'package:saathi/features/catalog/package.dart' as _i518;
import 'package:saathi/features/chat/data/chat_api.dart' as _i960;
import 'package:saathi/features/chat/data/chat_repository.dart' as _i971;
import 'package:saathi/features/chat/data/outbox.dart' as _i415;
import 'package:saathi/features/chat/data/session.dart' as _i468;
import 'package:saathi/features/safety/red_flag_detector.dart' as _i891;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;
import 'package:uuid/uuid.dart' as _i706;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i891.RedFlagDetector>(
      () => appModule.redFlagDetector,
      preResolve: true,
    );
    await gh.factoryAsync<_i518.Catalog>(
      () => appModule.catalog,
      preResolve: true,
    );
    gh.singleton<_i537.AppDatabase>(() => appModule.database);
    gh.lazySingleton<_i961.AppConfig>(() => _i961.AppConfig());
    gh.lazySingleton<_i961.Clock>(() => _i961.Clock());
    gh.lazySingleton<_i519.Client>(() => appModule.httpClient);
    gh.lazySingleton<_i454.SupabaseClient>(() => appModule.supabase);
    gh.lazySingleton<_i706.Uuid>(() => appModule.uuid);
    gh.lazySingleton<_i468.SessionTokens>(
      () => _i468.SupabaseSessionTokens(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i960.ChatApi>(
      () => _i960.ChatApi(
        gh<_i519.Client>(),
        gh<_i961.AppConfig>(),
        gh<_i468.SessionTokens>(),
      ),
    );
    gh.lazySingleton<_i370.ConnectivityService>(
      () => _i370.ConnectivityService(gh<_i960.ChatApi>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i415.Outbox>(
      () => _i415.Outbox(
        gh<_i537.AppDatabase>(),
        gh<_i960.ChatApi>(),
        gh<_i370.ConnectivityService>(),
        gh<_i961.Clock>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i971.ChatRepository>(
      () => _i971.ChatRepository(
        gh<_i537.AppDatabase>(),
        gh<_i415.Outbox>(),
        gh<_i891.RedFlagDetector>(),
        gh<_i961.Clock>(),
        gh<_i706.Uuid>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i800.AppModule {}
