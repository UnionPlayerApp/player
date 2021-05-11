import 'dart:async';
import 'package:union_player_app/repository/i_schedule_repository.dart';
import 'package:union_player_app/repository/schedule_item_raw.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/constants/constants.dart';

class ScheduleRepositoryImpl implements IScheduleRepository {
  final AppLogger _logger;

  ScheduleRepositoryImpl(this._logger) {
    stream();
  }

  bool _isOpen = true;

  List<ScheduleItemRaw> _itemsRaw = List.empty(growable: true);

  List<ScheduleItemRaw> _testItemsRaw = [
    ScheduleItemRaw(DateTime.now(), Duration(minutes: 53), "Утренняя зарядка",
        "Владимир Высоцкий",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRygBKRZC_XhwMXnmXT-Wq_8TGT4MSkV3KY-A&usqp=CAU"),
    ScheduleItemRaw(DateTime.now().add(Duration(hours: 1)),
        Duration(minutes: 43), "Угадай страну", "Дмитрий Дибров",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsh0I61KOzNAOzvjEmMUKjmH9EZwxB2UGovg&usqp=CAU"),
    ScheduleItemRaw(DateTime.now().add(Duration(hours: 2)),
        Duration(minutes: 33), "Радио!", "Несчастный случай",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhUkOp_uSZY5R2gsHMxKt6nTIy-isvdm7pxQ&usqp=CAU"),
    ScheduleItemRaw(DateTime.now().add(Duration(hours: 3)),
        Duration(minutes: 23), "Лейся песня на просторе!", "Андрей Макаревич",
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
  List<ScheduleItemRaw> getScheduleList() {
    return _itemsRaw;
  }

  @override
  ScheduleItemRaw? getCurrentItem() {
    return _firstItemIsCurrent() ? _itemsRaw[0] : null;
  }

  @override
  Stream<ScheduleRepositoryState> stream() async* {
    while (_isOpen) {
      Future.delayed(Duration(seconds: SCHEDULE_CHECK_INTERVAL));

      if (!_firstItemIsCurrent()) {
        yield await _load();
      }
    }
  }

  bool _firstItemIsCurrent() {
    if (_itemsRaw.isEmpty) return false;

    final item = _itemsRaw[0];
    final finish = item.start.add(item.duration);
    final now = DateTime.now();

    return (finish.isAfter(now));
  }

  Future<ScheduleRepositoryState> _load() async {
    return ScheduleRepositoryLoadSuccessState(_testItemsRaw);
  }

  @override
  void close() {
    _isOpen = false;
  }
}
