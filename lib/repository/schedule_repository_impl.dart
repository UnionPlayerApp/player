import 'package:union_player_app/model/schedule_item.dart';
import 'package:union_player_app/repository/i_schedule_repository.dart';
import 'package:union_player_app/screen_schedule/schedule_state.dart';

class ScheduleRepositoryImpl implements IScheduleRepository{

  ScheduleRepositoryImpl();

  List<ScheduleItem> _programList = [
    ScheduleItem(
        "Утренняя зарядка", "Благородные стремления не спасут: жизнь прекрасна",
        "12:00",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRygBKRZC_XhwMXnmXT-Wq_8TGT4MSkV3KY-A&usqp=CAU"),
    ScheduleItem("Угадай страну",
        "Повседневная практика показывает, что высокое качество позиционных исследований говорит о возможностях системы массового участия.",
        "15:00",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsh0I61KOzNAOzvjEmMUKjmH9EZwxB2UGovg&usqp=CAU"),
    ScheduleItem("О, радио!",
        "Свободу слова не задушить, пусть даже средства индивидуальной защиты оказались бесполезны",
        "15:30",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhUkOp_uSZY5R2gsHMxKt6nTIy-isvdm7pxQ&usqp=CAU"),
    ScheduleItem(
        "Играй, гармонь", "Сложно сказать, почему склады ломятся от зерна",
        "16:15",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRWS-O75WhJE-wnol-9NfBr54rmbsUc0LeDA&usqp=CAU"),
    ScheduleItem("Новости",
        "Каждый из нас понимает очевидную вещь: повышение уровня гражданского сознания требует определения и уточнения соответствующих условий активизации.",
        "17:00", null),
    ScheduleItem("Ночь оказалась долгой",
        "И по сей день в центральных регионах звучит перекатами старческий скрип Амстердама.",
        "18:00",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoydUqpTZ-TQ2h-IDrwIwuQjtWd44w2IXPWQ&usqp=CAU")
  ];

  @override
  Future<ScheduleState> getScheduleList() async {
    return ScheduleLoadSuccessState(_programList);
    // Testing error state:
    // return ScheduleLoadErrorState("[error message]");
  }
}