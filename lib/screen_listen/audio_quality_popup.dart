import 'package:flutter/material.dart';
import 'package:union_player_app/utils/core/string_keys.dart';
import 'package:union_player_app/utils/enums/audio_quality_type.dart';
import 'package:union_player_app/utils/widgets/common_dialog.dart';
import 'package:union_player_app/utils/widgets/common_radio_list.dart';

import '../utils/widgets/common_text_button.dart';

class AudioQualityPopup {
  AudioQualityType audioQualityType;

  AudioQualityPopup({required this.audioQualityType});

  Future<AudioQualityType?> show(BuildContext context) {
    return showDialog<AudioQualityType>(
      context: context,
      builder: (context) => CommonDialog(
        context,
        title: StringKeys.settingsQualityLabel,
        content: _content(context),
        actions: [
          CommonTextButton(
            context,
            onPressed: () => Navigator.of(context).pop(audioQualityType),
            textKey: StringKeys.buttonOk,
          ),
          CommonTextButton(
            context,
            onPressed: () => Navigator.of(context).pop(),
            textKey: StringKeys.buttonCancel,
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          return CommonRadioList<AudioQualityType>(
            keys: const [
              StringKeys.settingsQualityLow,
              StringKeys.settingsQualityMedium,
              StringKeys.settingsQualityHigh,
            ],
            values: const [
              AudioQualityType.low,
              AudioQualityType.medium,
              AudioQualityType.high,
            ],
            groupValue: audioQualityType,
            onChanged: (value) => _onChanged(value, setState),
          );
        },
      );

  void _onChanged(AudioQualityType? value, StateSetter setState) {
    setState(() {
      audioQualityType = value ?? AudioQualityType.unknown;
    });
  }
}
