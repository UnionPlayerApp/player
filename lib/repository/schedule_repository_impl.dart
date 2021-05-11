import 'package:union_player_app/repository/schedule_item_raw.dart';
import 'package:union_player_app/repository/i_schedule_repository.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';

class ScheduleRepositoryImpl implements IScheduleRepository {
  ScheduleRepositoryImpl();

  List<ScheduleItemRaw> _scheduleListRaw = [
    ScheduleItemRaw(
        DateTime.now(),
        Duration(minutes: 53),
        "Утренняя зарядка",
        "Владимир Высоцкий",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRygBKRZC_XhwMXnmXT-Wq_8TGT4MSkV3KY-A&usqp=CAU"),
    ScheduleItemRaw(
        DateTime.now().add(Duration(hours: 1)),
        Duration(minutes: 43),
        "Угадай страну",
        "Дмитрий Дибров",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsh0I61KOzNAOzvjEmMUKjmH9EZwxB2UGovg&usqp=CAU"),
    ScheduleItemRaw(
        DateTime.now().add(Duration(hours: 2)),
        Duration(minutes: 33),
        "Радио!",
        "Несчастный случай",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhUkOp_uSZY5R2gsHMxKt6nTIy-isvdm7pxQ&usqp=CAU"),
    ScheduleItemRaw(
        DateTime.now().add(Duration(hours: 3)),
        Duration(minutes: 23),
        "Лейся песня на просторе!",
        "Андрей Макаревич",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRWS-O75WhJE-wnol-9NfBr54rmbsUc0LeDA&usqp=CAU"),
    ScheduleItemRaw(
      DateTime.now().add(Duration(hours: 4)),
      Duration(minutes: 13),
      "Новости",
      "Анна Невская",
    ),
    ScheduleItemRaw(
        DateTime.now().add(Duration(hours: 5)),
        Duration(minutes: 3),
        "Ночь оказалась долгой",
        "И по сей день в центральных регионах звучит перекатами старческий скрип Амстердама.",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoydUqpTZ-TQ2h-IDrwIwuQjtWd44w2IXPWQ&usqp=CAU")
  ];

  @override
  Future<ScheduleRepositoryState> getScheduleList() async {
    return ScheduleRepositoryLoadSuccessState(_scheduleListRaw);
    // Testing error state:
    // return ScheduleRepositoryLoadErrorState("[error message]");
  }
}
