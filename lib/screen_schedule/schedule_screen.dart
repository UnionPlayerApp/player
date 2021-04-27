import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:union_player_app/app/my_app_bar.dart';
import 'package:union_player_app/model/program_item.dart';
import 'package:union_player_app/repository/repository.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';

late Logger logger = Logger();

class ScheduleScreen extends StatefulWidget {
  late bool _isPlaying;
  late Repository _repository;

  //При переходе на экран расписания передаем информацию, играет ли радио, чтобы отобразить правильный значок в аппбаре:
  ScheduleScreen(Repository repository, bool isPlaying) {
    _repository = repository;
    _isPlaying = isPlaying;
  }

  @override
  createState() => ScheduleScreenState(_repository, _isPlaying);
}

class ScheduleScreenState extends State<ScheduleScreen> {
  IconData _appBarIcon = Icons.play_arrow_rounded;
  bool _isPlaying = false;
  late Repository _repository;
  late List<ProgramListItem> programListItems;


  ScheduleScreenState(Repository repository, bool isPlaying) {
    _repository = repository;
    _isPlaying = isPlaying;
    getList();
  }

  void getList() {
    List<ProgramItem> programItems = _repository.get();
    // Mapping:
    programListItems = [
      for (var mapEntry in programItems)
        ProgramListItem(mapEntry.title, mapEntry.text, mapEntry.startTime, mapEntry.imageUrl)
    ];
  }

  void _onButtonAppBarTapped() {
    _isPlaying = !_isPlaying;
    setState(() {
      if (_isPlaying)
        _appBarIcon = Icons.pause_rounded;
      else
        _appBarIcon = Icons.play_arrow_rounded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: MyAppBar(_onButtonAppBarTapped, _appBarIcon),
            body: Center(
                child:
                ListView.separated(
                    separatorBuilder: (BuildContext context,
                        int index) => Divider(height: listViewDividerHeight,),
                    itemCount: programListItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return programListItems[index];
                    }
                )),
        )
    );
  }
}

class ProgramListItem extends StatelessWidget {
  String title;
  String text;
  String startTime;
  String? imageUrl;

  ProgramListItem(this.title, this.text, this.startTime, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    late Image image;
    if (imageUrl != null && imageUrl != '') image = Image.network(imageUrl!, width: scheduleImageSide, height: scheduleImageSide, fit: BoxFit.cover);
    else image = Image.asset(logoImage,  width: scheduleImageSide, height: scheduleImageSide, fit: BoxFit.cover);
    logger.d("$LOG_TAG Image hight: ${image.height}");
    logger.d("$LOG_TAG Image width: ${image.width}");

    return Container(
        color: Colors.white10,
        margin: allSidesMargin,
        height: scheduleItemHeight,
        child: Row(children: [
          image,
          Expanded(
              child: Container(
                  padding: programTextLeftPadding,
                  child: Column(children: [
                    Row(children: [
                      Expanded(child: Text(title, style: TextStyle(fontSize: titleFontSize), softWrap: true, textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                      Text(startTime,  style: TextStyle(fontSize: titleFontSize), overflow: TextOverflow.ellipsis),
                    ]),
                    Container(
                        padding: programBodyTopPadding,
                        alignment: Alignment.centerLeft,
                        child: Text(text, style: TextStyle(fontSize: bodyFontSize), softWrap: true, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, maxLines: 3,))
                  ])
              )
          )
        ])
    );
  }
}