import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:union_player_app/screen_listen/media_item_progress.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/enums/image_source_type.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/ui/text_styles.dart';
import 'package:union_player_app/utils/widgets/live_air_widget.dart';

import '../screen_settings/popups/sound_quality_popup.dart';
import '../utils/ui/app_colors.dart';
import 'listen_bloc.dart';
import 'listen_event.dart';
import 'listen_item_view.dart';
import 'listen_state.dart';

// ignore: must_be_immutable
class ListenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> with TickerProviderStateMixin {

  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListenBloc, ListenState>(
      builder: (context, state) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _topActionWidget(context, state),
          _scheduleItemWidget(context, state),
          MediaItemProgress(start: state.itemView.start, finish: state.itemView.finish),
          _playerButton(context, state),
        ],
      ),
    );
  }

  Widget _imageWidgetFromFile(String imageSource) {
    final file = File(imageSource);
    return _imageContainer(Image.file(
      file,
      width: mainImageSize,
      height: mainImageSize,
      fit: BoxFit.cover,
    ));
  }

  Widget _imageWidgetFromAssets(String imageSource) {
    return _imageContainer(Image.asset(
      imageSource,
      width: mainImageSize,
      height: mainImageSize,
      fit: BoxFit.cover,
    ));
  }

  Widget _imageWidgetFromNetwork(String imageSource) {
    return _imageContainer(Image.network(
      imageSource,
      width: mainImageSize,
      height: mainImageSize,
      fit: BoxFit.cover,
    ));
  }

  Widget _imageContainer(Image image) {
    const radius = mainImageSize / 2;
    const offset = 10.0;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(color: Colors.black45, offset: Offset(offset, offset), blurRadius: 15, spreadRadius: 0),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: image,
      ),
    );
  }

  Widget _topActionWidget(BuildContext context, ListenState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: () => _showSoundQualityPopup(context, state),
            child: SvgPicture.asset(AppIcons.icAudioQuality),
          ),
        ],
      ),
    );
  }

  Widget _scheduleItemWidget(BuildContext context, ListenState state) {
    return Column(
      children: [
        Text(translate(state.itemView.labelKey, context), style: TextStyles.bold20BlackOlive),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => context.read<ListenBloc>().add(ListenBackStepEvent()),
              child: SvgPicture.asset(AppIcons.icArrowBack),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(AppImages.imDisk0),
                Image.asset(AppImages.imDisk1),
                Image.asset(AppImages.imDisk2),
                _scheduleImageWidget(state.itemView),
              ],
            ),
            InkWell(
              onTap: () => context.read<ListenBloc>().add(ListenForwardStepEvent()),
              child: SvgPicture.asset(AppIcons.icArrowForward),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        Text(state.itemView.isArtistVisible ? state.itemView.artist : " ", style: TextStyles.bold20BlackOlive),
        const SizedBox(height: 20.0),
        Text(state.itemView.title, style: TextStyles.regular16BlackOlive, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _scheduleImageWidget(ListenItemView itemView) {
    switch (itemView.imageSourceType) {
      case ImageSourceType.none:
        return const SizedBox();
      case ImageSourceType.file:
        return _imageWidgetFromFile(itemView.imageSource);
      case ImageSourceType.network:
        return _imageWidgetFromNetwork(itemView.imageSource);
      case ImageSourceType.assets:
        return _imageWidgetFromAssets(itemView.imageSource);
    }
  }

  Widget _playerButton(BuildContext context, ListenState state) {
    return GestureDetector(
      onTap: () => context.read<ListenBloc>().add(ListenPlayerButtonEvent()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(21.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.blueGreen,
                    AppColors.blueGreen.withOpacity(0.25),
                  ],
                ),
                borderRadius: const BorderRadius.all(Radius.circular(40.0))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LiveAirWidget(
                  animationController: _animationController,
                  color: AppColors.white,
                  isActive: state.isPlaying,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text("LIVE", style: TextStyles.regular22White),
                const SizedBox(width: 20.0),
                SvgPicture.asset(state.isPlaying ? AppIcons.icPause : AppIcons.icPlay),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSoundQualityPopup(BuildContext context, ListenState state) {
    SoundQualityPopup(initialValue: state.soundQualityType).show(context).then((soundQualityType) {
      if (soundQualityType != null) {
        context.read<ListenBloc>().add(ListenSoundQualityEvent(soundQualityType: soundQualityType));
      }
    });
  }
}
