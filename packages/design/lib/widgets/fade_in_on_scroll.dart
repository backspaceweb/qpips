import 'package:flutter/material.dart';

/// Fades + lifts a child into view on first build, with a small delay.
///
/// Cheap, approximate version of a scroll-triggered animation. For
/// content that's likely above the fold this gives a polished feel
/// without the cost of a real intersection observer. Below-the-fold
/// content gets the same treatment when it first builds.
class FadeInOnScroll extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double startOffsetY;

  const FadeInOnScroll({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.startOffsetY = 24,
  });

  @override
  State<FadeInOnScroll> createState() => _FadeInOnScrollState();
}

class _FadeInOnScrollState extends State<FadeInOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = Curves.easeOutCubic.transform(_controller.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, widget.startOffsetY * (1 - t)),
            child: widget.child,
          ),
        );
      },
    );
  }
}
