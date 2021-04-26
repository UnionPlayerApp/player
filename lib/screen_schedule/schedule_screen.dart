import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:union_player_app/model/program_item.dart';
import 'package:union_player_app/repository/repository.dart';
import 'package:union_player_app/ui/my_app_bar.dart';
import 'package:union_player_app/util/constants/constants.dart';
import 'package:union_player_app/util/localizations/app_localizations_delegate.dart';
import 'file:///C:/Users/lenak/AndroidStudioProjects/GeekBrainsProjects/player-master/lib/util/dimensions/dimensions.dart';
import '../ui/my_bottom_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

late Logger logger = Logger();

class ScheduleScreen extends StatefulWidget {
  late bool _isPlaying;
  late Repository _repository;

  //При переходе на экран расписания передаем информацию, играет ли радио, чтобы отобразить правильный значок в аппбаре:
  ScheduleScreen(repository, bool isPlaying) {
    _repository = repository;
    _isPlaying = isPlaying;
  }

  @override
  createState() => ScheduleScreenState(_repository, _isPlaying);
}

class ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedIndex = 1;
  IconData _appBarIcon = Icons.play_arrow_rounded;
  bool _isPlaying = false;
  late Repository _repository;
  late List<ProgramListItem> programListItems;


  ScheduleScreenState(Repository repository, bool isPlaying) {
    _repository = repository;
    _isPlaying = isPlaying;
    getList();
  }

  Future<List<ProgramListItem>?> getList() async{
    List<ProgramItem> programItems = await _repository.get();
    // Mapping:
    programListItems = [
      for (var mapEntry in programItems)
        ProgramListItem(mapEntry.title, mapEntry.text, mapEntry.startTime, mapEntry.imageUrl)
    ];
  }

  void _onBottomMenuItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      logger.d(
          "$LOG_TAG Bottom navigation selected item index: $_selectedIndex");
    });
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
    // Пока нет навигции между экранами и тестовый запуск экрана осуществляется через прямой вызов его в main,
    // инициализирую ScreenUtil в билдере каждого экрана, позже достаточно будет сделать это в билдере MyApp:
    return ScreenUtilInit(
        designSize: Size(prototypeDeviceWidth, prototypeDeviceHeight),
        builder: () =>
            MaterialApp(
                debugShowCheckedModeBanner: false,
                // Пока нет навигции между экранами и тестовый запуск экрана осуществляется через прямой вызов его в main,
                // прописываю параметры локализации в билдере каждого экрана, потом достаточно сделать это в билдере MyApp:
                localizationsDelegates: [
                  const AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('en', 'US'),
                  const Locale('ru', 'RU'),
                ],
                localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
                  for (Locale supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale?.languageCode || supportedLocale.countryCode == locale?.countryCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
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
                    bottomNavigationBar: MyBottomNavigationBar(
                        _selectedIndex, _onBottomMenuItemTapped)
                ))

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
