import 'package:flutter/material.dart';

class ProgressPage extends StatelessWidget {
  final String title;

  ProgressPage({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
}