import 'package:flutter/material.dart';

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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.radio),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Schedule',
         ),
          BottomNavigationBarItem(
            icon: Icon(Icons.markunread_mailbox_outlined),
            label: 'Feedback',
          ),
        ],

      currentIndex: currentIndex,
      selectedItemColor: Colors.red[800],
      onTap: onTap,
    );
  }
}