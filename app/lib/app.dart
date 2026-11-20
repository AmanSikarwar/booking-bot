import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import 'core/connectivity/connectivity_cubit.dart';
import 'core/di.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'features/chat/data/outbox.dart';
import 'features/chat/presentation/chat_cubit.dart';
import 'features/profile/profile_cubit.dart';
import 'features/settings/locale_cubit.dart';
import 'i18n/strings.g.dart';

class SaathiApp extends StatefulWidget {
  const SaathiApp({super.key});

  @override
  State<SaathiApp> createState() => _SaathiAppState();
}

class _SaathiAppState extends State<SaathiApp> {
  late final _lifecycle = AppLifecycleListener(onResume: getIt<Outbox>().kick);

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LocaleCubit>()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()),
        BlocProvider(create: (_) => getIt<ConnectivityCubit>()),
        BlocProvider(
          create: (_) {
            final cubit = getIt<ChatCubit>();
            unawaited(cubit.start(LocaleSettings.currentLocale.languageCode));
            return cubit;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Saathi',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        routerConfig: router,
        locale: TranslationProvider.of(context).flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
      ),
    );
  }
}
