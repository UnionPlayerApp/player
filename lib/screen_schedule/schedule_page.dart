import 'package:flutter/material.dart';
import 'package:union_player_app/model/program_item.dart';
import 'package:union_player_app/repository/repository.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';

class SchedulePage extends StatefulWidget {
  final Repository _repository;

  //При переходе на экран расписания передаем информацию, играет ли радио, чтобы отобразить правильный значок в аппбаре:
  SchedulePage(this._repository);

  @override
  createState() => SchedulePageState(_repository);
}

class SchedulePageState extends State<SchedulePage> {
  final Repository _repository;
  late List<ProgramListItem> programListItems;

  SchedulePageState(this._repository) {
    getList();
  }

  void getList() {
    List<ProgramItem> programItems = _repository.get();
    // Mapping:
    programListItems = [
      for (var mapEntry in programItems)
        ProgramListItem(mapEntry.title, mapEntry.text, mapEntry.startTime,
            mapEntry.imageUrl)
    ];
  }

  @override
  Widget build(BuildContext context) => Center(
      child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Divider(
                height: listViewDividerHeight,
              ),
          itemCount: programListItems.length,
          itemBuilder: (BuildContext context, int index) {
            return programListItems[index];
          }));
}

class ProgramListItem extends StatelessWidget {
  final String title;
  final String text;
  final String startTime;
  final String? imageUrl;

  ProgramListItem(this.title, this.text, this.startTime, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    late Image image;
    if (imageUrl != null && imageUrl != '') {
      image = Image.network(imageUrl!,
          width: scheduleImageSide,
          height: scheduleImageSide,
          fit: BoxFit.cover);
    } else {
      image = Image.asset(LOGO_IMAGE,
          width: scheduleImageSide,
          height: scheduleImageSide,
          fit: BoxFit.cover);
    }

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
                      Expanded(
                          child: Text(
                        title,
                        style: TextStyle(fontSize: titleFontSize),
                        softWrap: true,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      Text(startTime,
                          style: TextStyle(fontSize: titleFontSize),
                          overflow: TextOverflow.ellipsis),
                    ]),
                    Container(
                        padding: programBodyTopPadding,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          text,
                          style: TextStyle(fontSize: bodyFontSize),
                          softWrap: true,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ))
                  ])))
        ]));
  }
}
