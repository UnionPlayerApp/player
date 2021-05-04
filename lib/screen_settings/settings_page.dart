import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top:40),
      child: const Text(
        "Settings",
        style: TextStyle(
            fontSize: 22,
            color: Colors.lightBlue
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}