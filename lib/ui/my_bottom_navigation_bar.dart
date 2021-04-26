import 'package:flutter/material.dart';
import 'package:union_player_app/util/localizations/string_translation.dart';

class MyBottomNavigationBar extends StatelessWidget{
  late int currentIndex;
  late void Function(int)? onTap;

  MyBottomNavigationBar(int index,  void Function(int)? _onBottomMenuItemTapped) {
    currentIndex = index;
    onTap = _onBottomMenuItemTapped;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.radio),
            label: translate(StringKeys.home, context),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: translate(StringKeys.schedule, context),
         ),
          BottomNavigationBarItem(
            icon: Icon(Icons.markunread_mailbox_outlined),
            label: translate(StringKeys.feedback, context),
          ),
        ],

      currentIndex: currentIndex,
      selectedItemColor: Colors.red[800],
      onTap: onTap,
    );
  }
}