import 'package:flutter/material.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';

class NoDividerBanner extends MaterialBanner {
  const NoDividerBanner(Widget content, Widget? leading, List<Widget> actions)
      : super(content: content, actions: actions, leading: leading);

  Widget build(BuildContext context) {
    assert(actions.isNotEmpty);

    final ThemeData theme = Theme.of(context);
    final MaterialBannerThemeData bannerTheme = MaterialBannerTheme.of(context);

    final bool isSingleRow = actions.length == 1 && !forceActionsBelow;
    final EdgeInsetsGeometry padding = this.padding ??
        bannerTheme.padding ??
        (isSingleRow
            ? const EdgeInsetsDirectional.only(start: 16.0, top: 2.0)
            : const EdgeInsetsDirectional.only(start: 16.0, top: 24.0, end: 16.0, bottom: 4.0));
    final EdgeInsetsGeometry leadingPadding =
        this.leadingPadding ?? bannerTheme.leadingPadding ?? const EdgeInsetsDirectional.only(end: 16.0);

    final Widget buttonBar = Container(
      alignment: AlignmentDirectional.centerEnd,
      constraints: const BoxConstraints(minHeight: 52.0),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: OverflowBar(
        overflowAlignment: overflowAlignment,
        spacing: 8,
        children: actions,
      ),
    );

    final Color backgroundColor = this.backgroundColor ?? bannerTheme.backgroundColor ?? theme.colorScheme.surface;
    final TextStyle? textStyle = contentTextStyle ?? bannerTheme.contentTextStyle ?? theme.textTheme.bodyText2;

    return Container(
      height: bannerHeight,
      color: backgroundColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: padding,
            child: Row(
              children: <Widget>[
                if (leading != null)
                  Padding(
                    padding: leadingPadding,
                    child: leading,
                  ),
                Expanded(
                  child: DefaultTextStyle(
                    style: textStyle!,
                    child: content,
                  ),
                ),
                if (isSingleRow) buttonBar,
              ],
            ),
          ),
          if (!isSingleRow) buttonBar,
          // const Divider(height: 0),
        ],
      ),
    );
  }
}
