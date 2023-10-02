import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:union_player_app/common/constants/constants.dart';
import 'package:union_player_app/common/dimensions/dimensions.dart';
import 'package:union_player_app/common/enums/relative_time_type.dart';
import 'package:union_player_app/common/localizations/string_translation.dart';
import 'package:union_player_app/common/widgets/live_air_widget.dart';
import 'package:union_player_app/screen_schedule/schedule_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_item_view.dart';
import 'package:union_player_app/screen_schedule/schedule_state.dart';

import '../common/ui/app_colors.dart';
import '../common/widgets/snack_bar.dart';

// ignore: must_be_immutable
class SchedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with TickerProviderStateMixin {
  final _itemScrollController = ItemScrollController();
  final _itemPositionsListener = ItemPositionsListener.create();
  var _currentIndex = 0;

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
    return BlocConsumer<ScheduleBloc, ScheduleState>(
      listener: (context, state) => showSnackBar(context, messageText: state.errorText),
      builder: (context, state) => (state is ScheduleLoadedState) ? _loadedPage(context, state) : _loadingPage(),
    );
  }

  Widget _loadingPage() => const Center(child: CircularProgressIndicator());

  Widget _loadedPage(BuildContext context, ScheduleLoadedState state) {
    _currentIndex = state.currentIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToCurrentItem());

    return ScrollablePositionedList.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(height: listViewDividerHeight),
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
      itemCount: state.items.length,
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: EdgeInsets.all(scheduleItemPadding),
        child: _programElement(context, state.items[index]),
      ),
    );
  }

  Widget _programElement(BuildContext context, ScheduleItemView element) {
    return Row(
      children: [
        _imageWidget(element),
        Expanded(child: _textWidget(element, context)),
        if (element.timeType.isCurrent) ...[
          LiveAirWidget(animationController: _animationController, color: AppColors.blueGreen, isActive: true),
          const SizedBox(width: 8.0),
        ],
        _startWidget(element, context),
      ],
    );
  }

  Widget _startWidget(ScheduleItemView element, BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (element.start.date != null) ...[
            Text(element.start.date!, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6.0),
          ],
          if (element.start.dateLabel != null) ...[
            Text(translate(element.start.dateLabel!, context), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6.0),
          ],
          Text(
            element.start.time,
            style: Theme.of(context).textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );

  Text _titleWidget(ScheduleItemView element, BuildContext context) => Text(
        element.title,
        style: Theme.of(context).textTheme.titleSmall,
        softWrap: true,
        textAlign: TextAlign.start,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );

  Text _artistWidget(ScheduleItemView element, BuildContext context) => Text(
        element.artist,
        style: Theme.of(context).textTheme.bodySmall,
        softWrap: true,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      );

  Widget _imageWidget(ScheduleItemView element) {
    const imageSize = 78.0;
    const radius = imageSize / 2;
    const offset = 6.0;

    late final Image image;
    if (element.imageUri != null && element.imageUri!.path.isNotEmpty) {
      final file = File.fromUri(element.imageUri!);
      image = Image.file(file, width: imageSize, height: imageSize, fit: BoxFit.cover);
    } else {
      image = Image.asset(logoImage, width: imageSize, height: imageSize, fit: BoxFit.cover);
    }

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

  Widget _textWidget(ScheduleItemView element, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scheduleItemPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget(element, context),
          if (element.artist.isNotEmpty) ...[
            SizedBox(height: scheduleItemPadding),
            _artistWidget(element, context),
          ],
        ],
      ),
    );
  }

  void _jumpToCurrentItem() {
    if (_currentIndex != -1) {
      _itemScrollController.jumpTo(
        index: _currentIndex,
        alignment: 0.5,
      );
    }
  }
}
