
import 'package:union_player_app/model/program_item.dart';
import 'package:union_player_app/repository/repository.dart';

class ScheduleRepository extends Repository{

  ScheduleRepository();

  List<ProgramItem> _programList = [
    ProgramItem(
        "Утренняя зарядка", "Благородные стремления не спасут: жизнь прекрасна",
        "12:00",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRygBKRZC_XhwMXnmXT-Wq_8TGT4MSkV3KY-A&usqp=CAU"),
    ProgramItem("Угадай страну",
        "Повседневная практика показывает, что высокое качество позиционных исследований говорит о возможностях системы массового участия.",
        "15:00",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsh0I61KOzNAOzvjEmMUKjmH9EZwxB2UGovg&usqp=CAU"),
    ProgramItem("О, радио!",
        "Свободу слова не задушить, пусть даже средства индивидуальной защиты оказались бесполезны",
        "15:30",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhUkOp_uSZY5R2gsHMxKt6nTIy-isvdm7pxQ&usqp=CAU"),
    ProgramItem(
        "Играй, гармонь", "Сложно сказать, почему склады ломятся от зерна",
        "16:15",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRWS-O75WhJE-wnol-9NfBr54rmbsUc0LeDA&usqp=CAU"),
    ProgramItem("Новости",
        "Каждый из нас понимает очевидную вещь: повышение уровня гражданского сознания требует определения и уточнения соответствующих условий активизации.",
        "17:00", null),
    ProgramItem("Ночь оказалась долгой",
        "И по сей день в центральных регионах звучит перекатами старческий скрип Амстердама.",
        "18:00",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoydUqpTZ-TQ2h-IDrwIwuQjtWd44w2IXPWQ&usqp=CAU")
  ];


  @override
  Future<List<ProgramItem>> get() async{
    return _programList;
  }

}