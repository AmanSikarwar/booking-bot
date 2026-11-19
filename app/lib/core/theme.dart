import 'package:material_ui/material_ui.dart';

import '../gen/fonts.gen.dart';

abstract final class Palette {
  static const ink = Color(0xFF1E2532);
  static const inkMuted = Color(0xFF5B6472);
  static const paper = Color(0xFFF3F5F7);
  static const surface = Color(0xFFFFFFFF);
  static const line = Color(0xFFDDE2E8);
  static const lavender = Color(0xFF6B55A3);
  static const lavenderSoft = Color(0xFFECE8F6);
  static const urgent = Color(0xFFB42318);
  static const crisis = Color(0xFF2F5DA8);
  static const success = Color(0xFF1F7A4D);
}

enum Tube {
  lavender(Color(0xFF8C7BD1)),
  grey(Color(0xFF9AA1A9)),
  gold(Color(0xFFE3B23C)),
  urine(Color(0xFFD9A400));

  const Tube(this.color);

  final Color color;
}

final _lavenderTests = RegExp(r'\b(cbc|hba1c|esr)\b', caseSensitive: false);
final _greyTests = RegExp(r'blood sugar', caseSensitive: false);
final _urineTests = RegExp(r'urine', caseSensitive: false);

List<Tube> tubesFor(List<String> tests) {
  final tubes = <Tube>{};
  for (final t in tests) {
    if (_urineTests.hasMatch(t)) {
      tubes.add(Tube.urine);
    } else if (_greyTests.hasMatch(t)) {
      tubes.add(Tube.grey);
    } else if (_lavenderTests.hasMatch(t)) {
      tubes.add(Tube.lavender);
    } else {
      tubes.add(Tube.gold);
    }
  }
  return Tube.values.where(tubes.contains).toList();
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: Palette.lavender,
    primary: Palette.lavender,
    surface: Palette.surface,
    onSurface: Palette.ink,
    error: Palette.urgent,
  );
  const fallback = [FontFamily.notoSansDevanagari];
  final base = ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: Palette.paper,
    fontFamily: FontFamily.notoSans,
    fontFamilyFallback: fallback,
  );
  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Palette.surface,
      foregroundColor: Palette.ink,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: Palette.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Palette.line),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 44),
        side: const BorderSide(color: Palette.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      side: const BorderSide(color: Palette.line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}

const tabular = [FontFeature.tabularFigures()];
