import 'dart:async';

import 'package:flutter/material.dart';

import '../common/ui/app_colors.dart';

class MediaItemProgress extends StatefulWidget {
  final DateTime start;
  final DateTime finish;

  const MediaItemProgress({required this.start, required this.finish});

  @override
  State<StatefulWidget> createState() => _MediaItemProgressState();
}

class _MediaItemProgressState extends State<MediaItemProgress> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const indicatorSize = 20.0;
      const strokeSize = 2.0;

      if (widget.start.isAfter(widget.finish)) {
        return SizedBox.fromSize(size: Size(constraints.maxWidth, indicatorSize));
      }

      final now = DateTime.now();

      final double ratio;

      if (now.isBefore(widget.start)) {
        ratio = 0.0;
      } else if (now.isAfter(widget.finish)) {
        ratio = 1.0;
      } else {
        final dItem = widget.finish.millisecondsSinceEpoch - widget.start.millisecondsSinceEpoch;
        final dNow = now.millisecondsSinceEpoch - widget.start.millisecondsSinceEpoch;
        ratio = dNow / dItem;
      }

      final maxPosition = constraints.maxWidth - indicatorSize;
      final position = ratio * maxPosition;

      if (ratio < 1.0) {
        _timer?.cancel();
        _timer = Timer(const Duration(seconds: 1), () => setState(() {}));
      }

      return Stack(
        children: [
          Container(
            height: indicatorSize,
            width: double.infinity,
            alignment: Alignment.center,
            child: const Divider(
              thickness: strokeSize,
              indent: indicatorSize / 2,
              endIndent: indicatorSize / 2,
              color: AppColors.gray,
            ),
          ),
          Positioned(
            left: position,
            child: Container(
              height: indicatorSize,
              width: indicatorSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(indicatorSize / 2),
                color: AppColors.blueGreen,
                boxShadow: [
                  BoxShadow(color: AppColors.blueGreen.withOpacity(0.5), blurRadius: 20),
                ],
              ),
            ),
          ),
          Container(
            height: indicatorSize,
            width: position,
            alignment: Alignment.centerLeft,
            child: const Divider(
              thickness: strokeSize,
              color: AppColors.blueGreen,
            ),
          ),
        ],
      );
    });
  }
}
