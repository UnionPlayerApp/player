import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:union_player_app/common/localizations/string_translation.dart';
import 'package:union_player_app/common/widgets/snack_bar.dart';
import 'package:union_player_app/screen_about_app/about_app_event.dart';
import 'package:union_player_app/screen_about_app/developer_model.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc.add(AboutAppInitEvent(locale: Localizations.localeOf(context)));
  }

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
      body: BlocConsumer<AboutAppBloc, AboutAppState>(
        listenWhen: (_, state) => state is AboutAppLoadedState && state.toastKey != null,
        listener: (context, state) {
          state as AboutAppLoadedState;
          final message = state.toastParam == null
              ? translate(state.toastKey!, context)
              : "${translate(state.toastKey!, context)}: ${state.toastParam}";
          showSnackBar(context, messageText: message);
        },
        builder: (context, state) => _stateWidget(context, state),
      ),
    );
  }

  Widget _stateWidget(BuildContext context, AboutAppState state) {
    switch (state.runtimeType) {
      case AboutAppLoadedState:
        return _loadedWidget(context, state as AboutAppLoadedState);
      case AboutAppLoadingState:
      default:
        return _loadingWidget();
    }
  }

  Widget _loadedWidget(BuildContext context, AboutAppLoadedState state) => Column(
        children: [
          const SizedBox(height: 30.0),
          _appLogoWidget(),
          _versionWidget(context, state),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) => _personWidget(context, model: state.developers[index]),
              separatorBuilder: (_, index) => const SizedBox(height: 30.0),
              itemCount: state.developers.length,
            ),
          ),
        ],
      );

  Widget _loadingWidget() => const Center(child: CircularProgressIndicator());

  Widget _personWidget(BuildContext context, {required DeveloperModel model}) {
    final text = "${translate(model.roleKey, context)} - ${model.firstName} ${model.lastName}";
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(text, style: TextStyles.regular16BlackOlive),
          const SizedBox(height: 15.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (model.email != null) ...[
                _contactButton(assetPath: AppIcons.icEmail, event: AboutAppEmailEvent(developerModel: model)),
              ],
              if (model.telegram != null) ...[
                _contactButton(assetPath: AppIcons.icTelegram, event: AboutAppTelegramEvent(developerModel: model)),
              ],
              if (model.whatsapp != null) ...[
                _contactButton(assetPath: AppIcons.icWhatsapp, event: AboutAppWhatsappEvent(developerModel: model)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactButton({required String assetPath, required AboutAppContactEvent event}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: InkWell(
          onTap: () => _bloc.add(event),
          child: SvgPicture.asset(assetPath),
        ),
      );

  Widget _appLogoWidget() => Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(AppImages.imRadioLogo, width: 125.0, height: 125.0),
          Image.asset(AppImages.imCircle150Blur8),
        ],
      );

  Widget _versionWidget(BuildContext context, AboutAppLoadedState state) {
    final text = "${translate(StringKeys.versionLabel, context)} ${state.version} (${state.buildNumber})";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Text(text, style: TextStyles.regular16BlackOlive),
    );
  }
}
