import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_ui/material_ui.dart';

abstract final class Motion {
  static bool enabled = true;
  static const fast = Duration(milliseconds: 180);
  static const normal = Duration(milliseconds: 280);
  static const stagger = Duration(milliseconds: 60);
  static const curve = Curves.easeOutCubic;

  static bool on(BuildContext context) => enabled && !MediaQuery.disableAnimationsOf(context);
}

final _seen = <String>{};

extension MotionX on Widget {
  Widget enter(BuildContext context, {Duration delay = Duration.zero, double rise = 8}) {
    if (!Motion.on(context)) return this;
    return animate(delay: delay)
        .fadeIn(duration: Motion.normal, curve: Motion.curve)
        .moveY(begin: rise, end: 0, duration: Motion.normal, curve: Motion.curve);
  }

  Widget enterOnce(BuildContext context, String id, {Duration delay = Duration.zero}) {
    if (!_seen.add(id)) return this;
    return enter(context, delay: delay);
  }

  Widget pop(BuildContext context, {Duration delay = Duration.zero}) {
    if (!Motion.on(context)) return this;
    return animate(delay: delay)
        .fadeIn(duration: Motion.fast)
        .scaleXY(begin: 0.6, end: 1, duration: 420.ms, curve: Curves.easeOutBack);
  }
}

List<Widget> staggered(
  BuildContext context,
  List<Widget> children, {
  Duration interval = Motion.stagger,
}) {
  if (!Motion.on(context)) return children;
  return children
      .animate(interval: interval)
      .fadeIn(duration: Motion.normal, curve: Motion.curve)
      .moveY(begin: 8, end: 0, duration: Motion.normal, curve: Motion.curve);
}
