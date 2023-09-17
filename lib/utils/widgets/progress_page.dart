import 'package:flutter/material.dart';
import 'package:union_player_app/utils/ui/app_theme.dart';
import 'package:union_player_app/utils/widgets/flags_widget.dart';

class ProgressPage extends StatelessWidget {
  final String _version;

  const ProgressPage({required String version}) : _version = version;

  @override
  Widget build(BuildContext context) {
    final width = {
      FlagsWidgetMode.init: MediaQuery.of(context).size.width,
    };
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        titleSpacing: 0,
        title: FlagsWidget(
          width: width,
          height: kToolbarHeight,
          mode: FlagsWidgetMode.init,
          backgroundColor: primaryColor,
        ),
      ),
      body: Stack(
        children: [
          const Center(child: CircularProgressIndicator()),
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
