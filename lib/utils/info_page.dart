import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  final List<String> strings;

  InfoPage({Key? key, required this.strings})
      : assert(strings.isNotEmpty),
        super(key: key);

  Widget mapStr(BuildContext context, String str) =>
      Text(str, style: Theme.of(context).textTheme.bodyText2);

  List<Widget> createChildren(BuildContext context) =>
      strings.sublist(1).map((str) => mapStr(context, str)).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(strings[0])),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: createChildren(context),
          ),
        ),
      );
}
