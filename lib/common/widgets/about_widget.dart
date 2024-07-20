import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:union_player_app/common/enums/string_keys.dart';

import '../constants/constants.dart';
import '../localizations/string_translation.dart';

abstract class AboutWidgetState<W extends StatefulWidget, B extends Bloc> extends State<W> {
  late final bloc = BlocProvider.of<B>(context);

  var _isNotDataInitialized = true;

  StringKeys get titleKey;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isNotDataInitialized) {
      initData();
      _isNotDataInitialized = false;
    }
  }

  void initData() {
    // nothing
  }

  Widget bodyBuilder(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 20.r,
          icon: SvgPicture.asset(
            AppIcons.icArrowBack,
            colorFilter: ColorFilter.mode(Theme.of(context).appBarTheme.titleTextStyle!.color!, BlendMode.srcIn),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(translate(titleKey, context)),
      ),
      body: bodyBuilder(context),
    );
  }
}
