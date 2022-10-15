import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_state.dart';
import 'package:union_player_app/utils/core/image_source_type.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/ui/app_theme.dart';

import 'main_item_view.dart';

class MainPage extends StatelessWidget {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) =>
          Stack(
            children: [
              _scrollWidget(context, state),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: _middleButton(context),
              // )
            ],
          ),
      bloc: get<MainBloc>(),
    );
  }

  Widget _scrollWidget(BuildContext context, MainState state) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: backgroundColor,
      child: ListWheelScrollView(
        controller: _scrollController,
        itemExtent: mainItemExtent,
        diameterRatio: 2.5,
        squeeze: 0.95,
        children: state.items.map((mainItemView) => _scrollItem(context, mainItemView)).toList(growable: false),
      ),
    );
  }

  Widget _scrollItem(BuildContext context, MainItemView item) {
    final children = List<Widget>.empty(growable: true);

    children.add(_stateTextWidget(context, _timeStateText(context, item), Theme.of(context).textTheme.headline6));

    switch (item.imageSourceType) {
      case ImageSourceType.none:
        break;
      case ImageSourceType.file:
        children.add(_imageWidgetFromFile(item.imageSource));
        break;
      case ImageSourceType.network:
        children.add(_imageWidgetFromNetwork(item.imageSource));
        break;
      case ImageSourceType.assets:
        children.add(_imageWidgetFromAssets(item.imageSource));
        break;
    }

    children.add(_stateTextWidget(context, item.title, Theme.of(context).textTheme.bodyText2));

    if (item.isArtistVisible) {
      children.add(_stateTextWidget(context, item.artist, Theme.of(context).textTheme.bodyText1));
    }

    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  String _timeStateText(BuildContext context, MainItemView item) {
    final timeStateKey = (item.isBeforeNow)
        ? StringKeys.prevLabel
        : (item.isNow) ? StringKeys.presLabel : StringKeys.nextLabel;
    return translate(timeStateKey, context);
  }

  Widget _stateTextWidget(BuildContext context, String stateStr, TextStyle? style) {
    final text = Text(stateStr, style: style, textAlign: TextAlign.center);
    return Container(margin: EdgeInsets.only(bottom: mainMarginBottom), child: text);
  }

  Widget _imageWidgetFromFile(String imageSource) {
    final file = File(imageSource);
    return _createContainer(Image.file(
      file,
      width: mainImageSide,
      height: mainImageSide,
      fit: BoxFit.cover,
    ));
  }

  Widget _imageWidgetFromAssets(String imageSource) {
    return _createContainer(Image.asset(
      imageSource,
      width: mainImageSide,
      height: mainImageSide,
      fit: BoxFit.cover,
    ));
  }

  Widget _imageWidgetFromNetwork(String imageSource) {
    return _createContainer(Image.network(
      imageSource,
      width: mainImageSide,
      height: mainImageSide,
      fit: BoxFit.cover,
    ));
  }

  Widget _createContainer(Image image) {
    const radius = 12.0;
    const offset = 10.0;
    return Container(
      margin: EdgeInsets.only(bottom: mainMarginBottom),
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
}
