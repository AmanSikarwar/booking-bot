import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saathi/core/layout.dart';
import 'package:saathi/core/theme.dart';
import 'package:saathi/features/chat/presentation/chat_screen.dart';
import 'package:saathi/features/profile/profile.dart';
import 'package:saathi/features/profile/profile_cubit.dart';
import 'package:saathi/i18n/strings.g.dart';

class MockProfileCubit extends MockCubit<Profile> implements ProfileCubit {}

void main() {
  final profile = MockProfileCubit();
  when(() => profile.state).thenReturn(sampleProfile);

  for (final locale in AppLocale.values) {
    for (final width in [360.0, 600.0, 700.0, 840.0, 960.0, 1080.0, 1120.0, 1199.0, 1440.0]) {
      for (final scale in [1.0, 1.5]) {
        testWidgets('header fits at ${width.toInt()}px, ${scale}x, ${locale.languageCode}', (
          tester,
        ) async {
          tester.view.physicalSize = Size(width, 800);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          LocaleSettings.setLocaleSync(locale);
          await tester.pumpWidget(
            TranslationProvider(
              child: MaterialApp(
                theme: buildTheme(),
                home: MediaQuery.withClampedTextScaling(
                  minScaleFactor: scale,
                  maxScaleFactor: scale,
                  child: BlocProvider<ProfileCubit>.value(
                    value: profile,
                    child: Builder(
                      builder: (context) => Scaffold(
                        appBar: SaathiAppBar(size: context.windowSize, onNewChat: () {}),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
