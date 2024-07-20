import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:union_player_app/common/constants/constants.dart';
import 'package:union_player_app/common/widgets/snack_bar.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';

import '../common/enums/nav_type.dart';
import '../common/enums/string_keys.dart';
import '../common/localizations/string_translation.dart';
import '../common/routes.dart';
import '../common/ui/font_sizes.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<AppPage> {
  static const _animationDuration = Duration(milliseconds: 300);

  DateTime? _backPressTime;
  Widget? _currentPage;

  late final _routes = GetIt.I.get<Routes>();
  late final _listenPage = _routes.page(context, routeName: Routes.listen);
  late final _schedulePage = _routes.page(context, routeName: Routes.schedule);
  late final _settingsPage = _routes.page(context, routeName: Routes.settings);

  AppBloc? _bloc;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.logEvent(name: gaAppStart);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc ??= BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (BuildContext context, AppState state) {
        return PopScope(
          canPop: false,
          onPopInvoked: _onPopInvoked,
          child: Scaffold(
            body: _body(state),
            bottomNavigationBar: _bottomNavigationBar(state),
          ),
        );
      },
    );
  }

  void _onPopInvoked(_) async {
    final now = DateTime.now();
    const duration = Duration(seconds: 2);
    if (_backPressTime == null || now.difference(_backPressTime!) > duration) {
      _backPressTime = now;
      showSnackBar(context, messageKey: StringKeys.pressAgainToExit, duration: duration);
    } else {
      await _bloc?.stop();
      FirebaseAnalytics.instance.logEvent(name: gaAppStop);
      SystemNavigator.pop();
    }
  }

  Widget _bottomNavigationBar(AppState state) => BottomAppBar(
        elevation: 0.0,
        child: SizedBox(
          height: (80 + 2 * 26).h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buttonAppBar(context, state, NavType.schedule, AppIcons.icSchedule, StringKeys.schedule),
              _buttonAppBar(context, state, NavType.listen, AppIcons.icListen, StringKeys.listen),
              _buttonAppBar(context, state, NavType.settings, AppIcons.icSettings, StringKeys.settings),
            ],
          ),
        ),
      );

  Widget _buttonAppBar(BuildContext context, AppState state, NavType navType, String iconName, StringKeys nameTab) {
    final iconSize = 24.r;
    final theme = Theme.of(context);
    final color = state.navType == navType
        ? theme.bottomNavigationBarTheme.selectedItemColor
        : theme.bottomNavigationBarTheme.unselectedItemColor;
    final textStyle = theme.textTheme.bodySmall!.copyWith(color: color, fontSize: FontSizes.px15);
    return Expanded(
      child: InkWell(
        onTap: () => _bloc?.add(AppNavEvent(navType: navType)),
        borderRadius: BorderRadius.circular(10.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconName,
              colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
              width: iconSize,
              height: iconSize,
            ),
            SizedBox(height: 8.h),
            Text(translate(nameTab, context), style: textStyle),
          ],
        ),
      ),
    );
  }

  Widget _body(AppState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: SafeArea(child: _createNavPage(state)),
    );
  }

  Widget _createNavPage(AppState state) {
    final navPage = _pageByNavType(state.navType);

    final navPageAnimated = _currentPage == null
        ? AnimatedOpacity(opacity: 1.0, duration: _animationDuration, child: navPage)
        : _currentPage == navPage
            ? navPage
            : AnimatedSwitcher(duration: _animationDuration, child: navPage);

    _currentPage = navPage;

    return AnimatedOpacity(
      opacity: 1.0,
      duration: _animationDuration,
      child: navPageAnimated,
    );
  }

  Widget _pageByNavType(NavType navType) {
    switch (navType) {
      case NavType.listen:
        return _listenPage;
      case NavType.schedule:
        return _schedulePage;
      case NavType.settings:
        return _settingsPage;
    }
  }
}
