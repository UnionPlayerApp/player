import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:union_player_app/my_app_bar.dart';

import 'my_bottom_navigation_bar.dart';
import 'main.dart';

const LOG_TAG = "UPA -> ";
late Logger logger = Logger();

class ScheduleScreen extends StatefulWidget {
  bool _isPlaying;

  //При переходе на экран расписания передаем информацию, играет ли радио, чтобы отобразить правильный значок в аппбаре:
  ScheduleScreen({required bool isPlaying}):_isPlaying = isPlaying;

  @override
  createState() => new ScheduleScreenState(isPlaying: _isPlaying);
}

class ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedIndex = 1;
  IconData _appBarIcon = Icons.play_circle_outline;
  bool _isPlaying = false;

  ScheduleScreenState({required bool isPlaying}):_isPlaying = isPlaying;

  List<ProgramListItem> _array = [
    new ProgramListItem("Утренняя зарядка", "Благородные стремления не спасут: жизнь прекрасна", "12:00", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRygBKRZC_XhwMXnmXT-Wq_8TGT4MSkV3KY-A&usqp=CAU"),
    new ProgramListItem("Угадай страну", "Повседневная практика показывает, что высокое качество позиционных исследований говорит о возможностях системы массового участия.", "15:00", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsh0I61KOzNAOzvjEmMUKjmH9EZwxB2UGovg&usqp=CAU"),
    new ProgramListItem("О, радио!", "Свободу слова не задушить, пусть даже средства индивидуальной защиты оказались бесполезны", "15:30", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhUkOp_uSZY5R2gsHMxKt6nTIy-isvdm7pxQ&usqp=CAU"),
    new ProgramListItem("Играй, гармонь", "Сложно сказать, почему склады ломятся от зерна", "16:15", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRWS-O75WhJE-wnol-9NfBr54rmbsUc0LeDA&usqp=CAU"),
    new ProgramListItem("Новости", "Каждый из нас понимает очевидную вещь: повышение уровня гражданского сознания требует определения и уточнения соответствующих условий активизации.", "17:00", imageUrl: ""),
    new ProgramListItem("Ночь оказалась долгой", "И по сей день в центральных регионах звучит перекатами старческий скрип Амстердама.", "18:00", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoydUqpTZ-TQ2h-IDrwIwuQjtWd44w2IXPWQ&usqp=CAU")
  ];

  void _onBottomMenuItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      logger.d("$LOG_TAG Bottom navigation selected item index: $_selectedIndex");
    });
  }

  void _onButtonAppBarTapped(){
    _isPlaying = !_isPlaying;
    setState(() {
      if(_isPlaying) _appBarIcon = Icons.pause_circle_outline;
          else _appBarIcon = Icons.play_circle_outline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
            debugShowCheckedModeBanner: false,
            home: new Scaffold(
                appBar: new MyAppBar(_onButtonAppBarTapped, _appBarIcon),
                body: new Center(
                    child:
                    new ListView.separated(
                        separatorBuilder: (BuildContext context, int index) => const Divider(height: 2.0,),
                        itemCount: _array.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _array[index];
                        }
                    )),
              bottomNavigationBar: MyBottomNavigationBar(_selectedIndex, _onBottomMenuItemTapped)
    ));
  }
}

class ProgramListItem extends StatelessWidget {
  final String _title;
  final String _text;
  final String _startTime;
  late String _imageUrl;

  ProgramListItem(this._title, this._text, this._startTime, {required String imageUrl}) {
    _imageUrl = imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    late Image image;
    if (_imageUrl != null && _imageUrl != '') image = Image.network(_imageUrl, width: 100.0, height: 100.0, fit: BoxFit.cover);
        else image = Image.asset("assets/images/union_radio_logo.png",  width: 100.0, height: 100.0, fit: BoxFit.cover);

    return new Container(
      color: Colors.white10,
      margin: EdgeInsets.all(16.0),
      height: 100.0,
      child: new Row(children: [
        image,
        new Expanded(
            child: new Container(padding: new EdgeInsets.only(left: 10.0, top: 5.0, right: 5.0, bottom: 5.0 ),
                child: new Column(children: [
                  new Row(children: [
                    new Expanded(child:new Text(_title, style: new TextStyle(fontSize: 17.0), softWrap: true, textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                    new Text(_startTime,  style: new TextStyle(fontSize: 17.0), overflow: TextOverflow.ellipsis),
                  ]),
                  new Container(
                    height: 10.0,
                  ),
                  new Container(
                      alignment: Alignment.centerLeft,
                      child: new Text(_text, softWrap: true, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, maxLines: 3,))
                ])
            )
        )
      ])
    );
  }
}
