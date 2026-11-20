import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/safety/red_flag_detector.dart';

void main() {
  final detector = RedFlagDetector(
    jsonDecode(File('assets/shared/red_flags.json').readAsStringSync()) as Map<String, Object?>,
  );
  final cases = (jsonDecode(File('../safety/red_flag_cases.json').readAsStringSync()) as List)
      .cast<Map<String, Object?>>();

  for (final c in cases) {
    test('red flag: ${c['text']}', () {
      final hit = detector.detect(c['text']! as String);
      expect(hit?.outcome.name ?? 'none', c['expected']);
      expect(hit?.soft ?? false, c['soft'] ?? false);
    });
  }

  test('urgent wins over crisis when both match', () {
    expect(
      detector.detect('I want to die, chest pain is unbearable')?.outcome,
      RedFlagOutcome.urgent,
    );
  });

  test('precomposed nukta letters match their plain forms', () {
    expect(normalize('तकलीफ़ ज़्यादा', const {}), 'तकलीफ ज्यादा');
    expect(normalize('ड़', const {}), normalize('ड़', const {}));
  });
}
