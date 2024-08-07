import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveAirWidget extends StatelessWidget {
  final _size = 9.r;

  final AnimationController animationController;
  final Color color;
  final bool isActive;

  LiveAirWidget({required this.animationController, required this.color, required this.isActive});

  late final Animation<double> _fadeAnimation = Tween<double>(begin: 1, end: 0.0).animate(animationController);

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
