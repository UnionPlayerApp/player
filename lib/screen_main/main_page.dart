import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_state.dart';
import 'package:union_player_app/utils/core/image_source_type.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) => _createWidget(context, state),
      bloc: get<MainBloc>(),
    );
  }

  Widget _createWidget(BuildContext context, MainState state) => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _createStateRows(context, state),
      ));

  List<Widget> _createStateRows(BuildContext context, MainState state) {
    final list = List<Widget>.empty(growable: true);

    list.add(_createStateRow(context, translate(state.itemLabelKey, context)));

    switch (state.imageSourceType) {
      case ImageSourceType.none:
        break;
      case ImageSourceType.file:
        list.add(_createImageFromFile(state.imageSource));
        break;
      case ImageSourceType.network:
        list.add(_createImageFromNetwork(state.imageSource));
        break;
      case ImageSourceType.assets:
        list.add(_createImageFromAssets(state.imageSource));
        break;
    }

    if (state.isTitleVisible) {
      list.add(_createStateRow(context, state.itemTitle));
    }

    if (state.isArtistVisible) {
      list.add(_createStateRow(context, state.itemArtist));
    }

    return list;
  }

  Widget _createStateRow(BuildContext context, String stateStr) {
    final text = Text(stateStr, style: Theme.of(context).textTheme.bodyText2);
    return Container(margin: EdgeInsets.only(bottom: mainMarginBottom), child: text);
  }

  Widget _createImageFromFile(String imageSource) {
    final file = File(imageSource);
    return _createContainer(Image.file(
      file,
      width: mainImageSide,
      height: mainImageSide,
      fit: BoxFit.cover,
    ));
  }

  Widget _createImageFromAssets(String imageSource) {
    return _createContainer(Image.asset(
      imageSource,
      width: mainImageSide,
      height: mainImageSide,
      fit: BoxFit.cover,
    ));
  }

  Widget _createImageFromNetwork(String imageSource) {
    return _createContainer(Image.network(
      imageSource,
      width: mainImageSide,
      height: mainImageSide,
      fit: BoxFit.cover,
    ));
  }

  Widget _createContainer(Image image) {
    return Container(margin: EdgeInsets.only(bottom: mainMarginBottom), child: image);
  }
}
