import 'package:flutter/material.dart';

const _TEXT_PADDING = 5.0;

class InfoPage extends StatelessWidget {
  final List<String> params;

  InfoPage({Key? key, required this.params})
      : assert(params.isNotEmpty),
        super(key: key);

  Widget mapStr(BuildContext context, String str) => Padding(
      padding: EdgeInsets.fromLTRB(
          _TEXT_PADDING, _TEXT_PADDING, _TEXT_PADDING, _TEXT_PADDING),
      child: Text(
        str,
        style: Theme.of(context).textTheme.bodyText2,
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
