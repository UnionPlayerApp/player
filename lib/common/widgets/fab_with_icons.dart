import 'package:flutter/material.dart';

class FabWithIcons extends StatefulWidget {
  final List<IconData> icons;
  final List<VoidCallback> actions;
  final List<String> tooltips;
  final IconData fabIcon;
  final VoidCallback fabAction;
  final String fabTooltip;

  const FabWithIcons({
    required this.icons,
    required this.actions,
    required this.tooltips,
    required this.fabIcon,
    required this.fabAction,
    required this.fabTooltip,
  }) : assert(icons.length == actions.length && icons.length == tooltips.length);

  @override
  State createState() => FabWithIconsState();
}

class FabWithIconsState extends State<FabWithIcons> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.icons.length, (int index) => _buildChild(index)).toList()..add(_buildFab()),
    );
  }

  Widget _buildChild(int index) {
    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 1.0 - index / widget.icons.length / 2.0, curve: Curves.easeOut),
        ),
        child: FloatingActionButton(
          mini: true,
          tooltip: widget.tooltips[index],
          onPressed: widget.actions[index],
          child: Icon(widget.icons[index]),
        ),
      ),
    );
  }

  Widget _buildFab() => Opacity(
    opacity: 0,
    child: FloatingActionButton(
          onPressed: widget.fabAction,
          tooltip: widget.fabTooltip,
          elevation: 2.0,
          child: Icon(widget.fabIcon),
        ),
  );
}
