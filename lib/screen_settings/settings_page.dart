import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';

class SettingsPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValueTheme = 'Светлая тема';
  String dropdownValueQuality = 'Среднее качество';
  String dropdownValueAutoPlay = 'Воспроизведение при старте включено';

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Text("Тема",
            style: TextStyle(fontSize: titleFontSize),
            overflow: TextOverflow.ellipsis),
      new DropdownButton<String>(
      value: dropdownValueTheme,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValueTheme = newValue!;
        });
      },
      items: <String>['Светлая тема', 'Тёмная тема', 'Системная тема']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ),

        new Text("Качество звука",
            style: TextStyle(fontSize: titleFontSize),
            overflow: TextOverflow.ellipsis),
        new DropdownButton<String>(
          value: dropdownValueQuality,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValueQuality = newValue!;
            });
          },
          items: <String>['Высокое качество', 'Среднее качество', 'Низкое качество', 'Авто']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),

        new Text("Воспроизведение при старте программы",
            style: TextStyle(fontSize: titleFontSize),
            overflow: TextOverflow.ellipsis),
        new DropdownButton<String>(
          value: dropdownValueAutoPlay,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValueAutoPlay = newValue!;
            });
          },
          items: <String>['Воспроизведение при старте включено', 'Воспроизведение при старте выключено']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
