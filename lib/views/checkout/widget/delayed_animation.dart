import 'package:flutter/material.dart';

class DelayedAnimation extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Animation<double> animation;

  const DelayedAnimation({
    super.key,
    required this.child,
    required this.delay,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final double animationValue = animation.value;
        if (animationValue < delay.inMilliseconds / 500.0) {
          return const SizedBox.shrink();
        }
        final double transformValue =
            (animationValue - delay.inMilliseconds / 500.0) * 2.0;
        return Transform(
          transform: Matrix4.translationValues(
              0.0, 50.0 * (1.0 - transformValue), 0.0),
          child: child,
        );
      },
      child: child,
    );
  }
}
