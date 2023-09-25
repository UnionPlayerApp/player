import 'package:flutter/material.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/ui/app_colors.dart';

class ProgressPage extends StatelessWidget {
  final String _version;

  const ProgressPage({required String version}) : _version = version;

  @override
  Widget build(BuildContext context) {
    const circleSize = 200.0;
    const imageSize = 150.0;
    return Scaffold(
      body: Stack(
        children: [
          const Center(
            child: SizedBox(
              width: circleSize,
              height: circleSize,
              child: CircularProgressIndicator(
                color: AppColors.blueGreen,
                strokeWidth: 6.0,
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          Center(child: Image.asset(logoImage, width: imageSize, height: imageSize)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(_version, style: Theme.of(context).textTheme.labelLarge),
            ),
          ),
        ],
      ),
    );
  }
}
