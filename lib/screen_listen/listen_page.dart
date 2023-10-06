import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:union_player_app/common/constants/constants.dart';
import 'package:union_player_app/common/core/extensions.dart';
import 'package:union_player_app/common/enums/image_source_type.dart';
import 'package:union_player_app/common/localizations/string_translation.dart';
import 'package:union_player_app/common/widgets/live_air_widget.dart';
import 'package:union_player_app/screen_listen/media_item_progress.dart';

import '../common/ui/app_colors.dart';
import '../screen_settings/popups/sound_quality_popup.dart';
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
  final _mainImageSize = 210.r;

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
          SizedBox(height: 9.h),
        ],
      ),
    );
  }

  Widget _imageWidgetFromFile(String imageSource) {
    final file = File(imageSource);
    return _imageContainer(Image.file(
      file,
      width: _mainImageSize,
      height: _mainImageSize,
      fit: BoxFit.cover,
    ));
  }

  Widget _imageWidgetFromAssets(String imageSource) {
    return _imageContainer(Image.asset(
      imageSource,
      width: _mainImageSize,
      height: _mainImageSize,
      fit: BoxFit.cover,
    ));
  }

  Widget _imageWidgetFromNetwork(String imageSource) {
    return _imageContainer(Image.network(
      imageSource,
      width: _mainImageSize,
      height: _mainImageSize,
      fit: BoxFit.cover,
    ));
  }

  Widget _imageContainer(Image image) {
    final borderRadius = BorderRadius.circular(_mainImageSize / 2);
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: image,
      ),
    );
  }

  Widget _topActionWidget(BuildContext context, ListenState state) {
    return Padding(
      padding: EdgeInsets.only(top: 27.h),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: () => _showSoundQualityPopup(context, state),
            child: SvgPicture.asset(
              AppIcons.icAudioQuality,
              width: 20.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(Theme.of(context).textTheme.titleMedium!.color!, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleItemWidget(BuildContext context, ListenState state) {
    final scale = ScreenUtil().scale;
    return Column(
      children: [
        Text(translate(state.itemView.labelKey, context), style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 19.h),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _arrowButton(context, assetName: AppIcons.icArrowBack, event: ListenBackStepEvent(), isStart: true),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(AppImages.imDisk0, scale: scale),
                Image.asset(AppImages.imDisk1, scale: scale),
                Image.asset(AppImages.imDisk2, scale: scale),
                _scheduleImageWidget(state.itemView),
              ],
            ),
            _arrowButton(context, assetName: AppIcons.icArrowForward, event: ListenForwardStepEvent(), isStart: false),
          ],
        ),
        SizedBox(height: 19.h),
        Text(
          state.itemView.isArtistVisible ? state.itemView.artist : " ",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 19.h),
        Text(
          state.itemView.title,
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _arrowButton(
    BuildContext context, {
    required String assetName,
    required ListenEvent event,
    required bool isStart,
  }) {
    final buttonHeight = 50.h;
    final arrowWidth = 11.w;
    final arrowHeight = 18.h;
    final colorFilter = ColorFilter.mode(Theme.of(context).textTheme.titleMedium!.color!, BlendMode.srcIn);
    final isTextDirectionLtr = Directionality.of(context).isLtr;
    final alignmentStart = isTextDirectionLtr ? Alignment.centerLeft : Alignment.centerRight;
    final alignmentEnd = isTextDirectionLtr ? Alignment.centerRight : Alignment.centerLeft;
    return Expanded(
      child: InkWell(
        onTap: () => context.read<ListenBloc>().add(event),
        child: Container(
          height: buttonHeight,
          alignment: isStart ? alignmentStart : alignmentEnd,
          child: SvgPicture.asset(
            assetName,
            height: arrowHeight,
            width: arrowWidth,
            colorFilter: colorFilter,
            fit: BoxFit.none,
          ),
        ),
      ),
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
    final contentStyle = Theme.of(context).textTheme.labelSmall;
    final contentColor = contentStyle!.color!;
    return GestureDetector(
      onTap: () => context.read<ListenBloc>().add(ListenPlayerButtonEvent()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 21.h, horizontal: 21.w),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.blueGreen,
                    AppColors.blueGreen.withOpacity(0.25),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(40.r))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LiveAirWidget(
                  animationController: _animationController,
                  color: contentColor,
                  isActive: state.isPlaying,
                ),
                SizedBox(width: 10.w),
                Text("LIVE", style: contentStyle),
                SizedBox(width: 20.w),
                SvgPicture.asset(
                  state.isPlaying ? AppIcons.icPause : AppIcons.icPlay,
                  colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
                  width: 22.w,
                  height: 30.h,
                ),
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
