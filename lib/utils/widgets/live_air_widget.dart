import 'package:flutter/material.dart';

class LiveAirWidget extends StatelessWidget {
  static const _size = 10.0;

  final TickerProvider tickerProvider;
  final Color color;
  final bool isActive;

  LiveAirWidget({required this.tickerProvider, required this.color, required this.isActive});

  late final _animationController = AnimationController(
    vsync: tickerProvider,
    duration: const Duration(seconds: 1),
  )..repeat();

  late final Animation<double> _fadeAnimation = Tween<double>(begin: 1, end: 0.0).animate(_animationController);

  @override
  Widget build(BuildContext context) => isActive
      ? FadeTransition(
          opacity: _fadeAnimation,
          child: _circleWidget(),
        )
      : _circleWidget();

  Container _circleWidget() => Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}
