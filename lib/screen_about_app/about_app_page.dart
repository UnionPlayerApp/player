import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:union_player_app/common/localizations/string_translation.dart';

import '../common/constants/constants.dart';
import '../common/enums/string_keys.dart';
import '../common/ui/app_colors.dart';
import '../common/ui/text_styles.dart';
import 'about_app_bloc.dart';
import 'about_app_state.dart';

class AboutAppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutAppPage> {
  late final _bloc = context.read<AboutAppBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.0,
        leading: IconButton(
          iconSize: 20.0,
          icon: SvgPicture.asset(AppIcons.icArrowBack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(translate(StringKeys.aboutApp, context), style: TextStyles.bold20BlackOlive),
      ),
      backgroundColor: AppColors.white,
      body: BlocBuilder<AboutAppBloc, AboutAppState>(
        builder: (context, state) => _stateWidget(context, state),
      ),
    );
  }

  Widget _stateWidget(BuildContext context, AboutAppState state) {
    switch (state.runtimeType) {
      case AboutAppLoadedState:
        return _loadedWidget();
      case AboutAppLoadingState:
      default:
        return _loadingWidget();
    }
  }

  Widget _loadedWidget() => Container();

  Widget _loadingWidget() => const Center(child: CircularProgressIndicator());
}
