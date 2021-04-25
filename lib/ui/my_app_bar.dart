
import 'package:flutter/material.dart';
import 'package:union_player_app/util/constants/constants.dart';

class MyAppBar extends AppBar{
  late Color backgroundColor;
  bool? centerTitle;
  late Widget leading;
  late List<Widget>? actions;

  MyAppBar(void Function() onTapFunction, IconData appBarIcon){
    backgroundColor = Colors.white;
    centerTitle = true;
    leading = new Container(padding: EdgeInsets.all(10.0), child: Image.asset(appBarLogoImage, fit: BoxFit.fill));
    actions = <Widget>[
      Padding(padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
              onTap: onTapFunction,
              child: Icon(
                  appBarIcon,
                  color: Colors.black38,
                  size: 26.0)
          )
      )
    ];
  }
}