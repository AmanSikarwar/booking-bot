import 'dart:async';

import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config.dart';
import 'core/connectivity/connectivity_service.dart';
import 'core/di.dart';
import 'features/chat/data/outbox.dart';
import 'features/settings/locale_cubit.dart';
import 'i18n/strings.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig();
  await Supabase.initialize(url: config.supabaseUrl, publishableKey: config.publishableKey);
  await initializeDateFormatting();
  await configureDependencies();
  await getIt<LocaleCubit>().load();
  unawaited(getIt<ConnectivityService>().start().then((_) => getIt<Outbox>().start()));
  runApp(TranslationProvider(child: const SaathiApp()));
}
