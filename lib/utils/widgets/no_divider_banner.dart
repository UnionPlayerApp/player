import 'package:flutter/material.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';

class NoDividerBanner extends MaterialBanner {
  const NoDividerBanner(
    Widget content,
    Widget leading,
    List<Widget> actions,
  ) : super(
          content: content,
          actions: actions,
          leading: leading,
          backgroundColor: Colors.blue,
        );

  Widget build(BuildContext context) {
    assert(actions.isNotEmpty);

    final bannerTheme = MaterialBannerTheme.of(context);
    final isSingleRow = actions.length == 1 && !forceActionsBelow;
    final padding = this.padding ??
        bannerTheme.padding ??
        (isSingleRow
            ? const EdgeInsetsDirectional.only(start: 16.0, top: 2.0)
            : const EdgeInsetsDirectional.only(start: 16.0, top: 24.0, end: 16.0, bottom: 4.0));
    final leadingPadding =
        this.leadingPadding ?? bannerTheme.leadingPadding ?? const EdgeInsetsDirectional.only(end: 16.0);

    final buttonBar = Container(
      alignment: AlignmentDirectional.centerEnd,
      constraints: const BoxConstraints(minHeight: 52.0),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: OverflowBar(
        overflowAlignment: overflowAlignment,
        spacing: 8,
        children: actions,
      ),
    );

    return SizedBox(
      height: bannerHeight,
      child: Column(
        children: [
          Padding(
            padding: padding,
            child: Row(
              children: [
                Padding(padding: leadingPadding, child: leading),
                Expanded(child: content),
                if (isSingleRow) buttonBar,
              ],
            ),
          ),
          if (!isSingleRow) buttonBar,
        ],
      ),
    );
  }
}
