import 'package:flutter/material.dart';
import 'package:union_player_app/utils/enums/audio_quality_type.dart';
import 'package:union_player_app/utils/widgets/common_dialog.dart';
import 'package:union_player_app/utils/widgets/common_radio_button.dart';

class AudioQualityPopup {
  AudioQualityType audioQualityType;

  AudioQualityPopup({required this.audioQualityType});

  Future<AudioQualityType?> show(BuildContext context) {
    return showDialog<AudioQualityType>(
      context: context,
      builder: (context) => CommonDialog(
        context,
        title: "Качество звука",
        content: _content(context),
        actions: [
          const Text("Ok"),
          const Text("Отмена"),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) => StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonRadioButton<AudioQualityType>(
              text: "Низкое",
              value: AudioQualityType.low,
              groupValue: audioQualityType,
              onChanged: (value) => _onChanged(value, setState),
            ),
            CommonRadioButton<AudioQualityType>(
              text: "Среднее",
              value: AudioQualityType.medium,
              groupValue: audioQualityType,
              onChanged: (value) => _onChanged(value, setState),
            ),
            CommonRadioButton<AudioQualityType>(
              text: "Высокое",
              value: AudioQualityType.high,
              groupValue: audioQualityType,
              onChanged: (value) => _onChanged(value, setState),
            )
          ],
        );
      });

  void _onChanged(AudioQualityType? value, StateSetter setState) {
    setState(() {
      audioQualityType = value ?? AudioQualityType.unknown;
    });
  }
}
