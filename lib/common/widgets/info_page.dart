import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoPage extends StatelessWidget {
  final List<String> params;

  InfoPage({Key? key, required this.params})
      : assert(params.isNotEmpty),
        super(key: key);

  Widget mapStr(BuildContext context, String str) => Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Text(
        str,
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      ));

  List<Widget> createChildren(BuildContext context) => params.sublist(1).map((str) => mapStr(context, str)).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(params[0]),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: createChildren(context),
          ),
        ),
      );
}
