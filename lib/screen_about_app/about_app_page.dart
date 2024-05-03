import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:union_player_app/common/localizations/string_translation.dart';
import 'package:union_player_app/common/widgets/app_logo_widget.dart';
import 'package:union_player_app/common/widgets/snack_bar.dart';
import 'package:union_player_app/screen_about_app/about_app_event.dart';
import 'package:union_player_app/screen_about_app/developer_model.dart';

import '../common/constants/constants.dart';
import '../common/enums/string_keys.dart';
import '../common/widgets/about_widget.dart';
import 'about_app_bloc.dart';
import 'about_app_state.dart';

class AboutAppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutAppState();
}

class _AboutAppState extends AboutWidgetState<AboutAppPage> {
  late final _bloc = context.read<AboutAppBloc>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc.add(AboutAppInitEvent(locale: Localizations.localeOf(context)));
  }

  @override
  StringKeys get titleKey => StringKeys.aboutApp;

  @override
  Widget bodyBuilder(BuildContext context) => BlocConsumer<AboutAppBloc, AboutAppState>(
        listenWhen: (_, state) => state is AboutAppLoadedState && state.toastKey != null,
        listener: (context, state) {
          state as AboutAppLoadedState;
          final message = state.toastParam == null
              ? translate(state.toastKey!, context)
              : "${translate(state.toastKey!, context)}: ${state.toastParam}";
          showSnackBar(context, messageText: message);
        },
        builder: (context, state) => _stateWidget(context, state),
      );

  Widget _stateWidget(BuildContext context, AboutAppState state) {
    switch (state) {
      case AboutAppLoadedState _:
        return _loadedWidget(context, state);
      case AboutAppLoadingState _:
      default:
        return _loadingWidget();
    }
  }

  Widget _loadedWidget(BuildContext context, AboutAppLoadedState state) => Column(
        children: [
          SizedBox(height: 30.h),
          const AppLogoWidget(),
          _versionWidget(context, state),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) => _personWidget(context, model: state.developers[index]),
              separatorBuilder: (_, index) => SizedBox(height: 30.h),
              itemCount: state.developers.length,
            ),
          ),
          _customerWidget(context),
        ],
      );

  Widget _loadingWidget() => const Center(child: CircularProgressIndicator());

  Widget _personWidget(BuildContext context, {required DeveloperModel model}) {
    final text = "${translate(model.roleKey, context)} - ${model.firstName} ${model.lastName}";
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: Column(
        children: [
          Text(text, style: Theme.of(context).textTheme.bodySmall),
          SizedBox(height: 15.h),
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
        padding: EdgeInsets.symmetric(horizontal: 15.h),
        child: InkWell(
          onTap: () => _bloc.add(event),
          child: SvgPicture.asset(assetPath),
        ),
      );

  Widget _versionWidget(BuildContext context, AboutAppLoadedState state) {
    final text = "${translate(StringKeys.versionLabel, context)} ${state.version} (${state.buildNumber})";
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }

  Widget _customerWidget(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: Column(
        children: [
          Text(translate(StringKeys.customerInfo, context), style: style, textAlign: TextAlign.center),
          SizedBox(height: 8.h),
          Text("2021 - 2023", style: style),
        ],
      ),
    );
  }
}
