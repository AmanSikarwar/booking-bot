import 'dart:async';

import 'package:saathi/core/motion.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  Motion.enabled = false;
  await testMain();
}
