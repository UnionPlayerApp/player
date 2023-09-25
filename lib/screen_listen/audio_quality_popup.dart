import 'package:flutter/material.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/enums/sound_quality_type.dart';
import 'package:union_player_app/utils/enums/string_keys.dart';
import 'package:union_player_app/utils/widgets/common_dialog.dart';
import 'package:union_player_app/utils/widgets/common_radio_list.dart';

import '../utils/widgets/common_text_button.dart';

class AudioQualityPopup {
  SoundQualityType soundQualityType;

  AudioQualityPopup({required this.soundQualityType});

  Future<SoundQualityType?> show(BuildContext context) {
    return showDialog<SoundQualityType>(
      context: context,
      builder: (context) => CommonDialog(
        context,
        title: StringKeys.settingsQualityLabel,
        content: _content(context),
        actions: [
          CommonTextButton(
            context,
            onPressed: () => Navigator.of(context).pop(soundQualityType),
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
          return CommonRadioList<SoundQualityType>(
            keys: const [
              StringKeys.settingsQualityLow,
              StringKeys.settingsQualityMedium,
              StringKeys.settingsQualityHigh,
            ],
            values: const [
              SoundQualityType.low,
              SoundQualityType.medium,
              SoundQualityType.high,
            ],
            groupValue: soundQualityType,
            onChanged: (value) => _onChanged(value, setState),
          );
        },
      );

  void _onChanged(SoundQualityType? value, StateSetter setState) {
    setState(() {
      soundQualityType = value ?? defaultSoundQualityType;
    });
  }
}
