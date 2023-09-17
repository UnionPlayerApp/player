import 'package:flutter/material.dart';

const _textPadding = 5.0;

class InfoPage extends StatelessWidget {
  final List<String> params;

  InfoPage({Key? key, required this.params})
      : assert(params.isNotEmpty),
        super(key: key);

  Widget mapStr(BuildContext context, String str) => Padding(
      padding: const EdgeInsets.fromLTRB(
          _textPadding, _textPadding, _textPadding, _textPadding),
      child: Text(
        str,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ));

  List<Widget> createChildren(BuildContext context) =>
      params.sublist(1).map((str) => mapStr(context, str)).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(params[0])),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: createChildren(context),
          ),
        ),
      );
}
