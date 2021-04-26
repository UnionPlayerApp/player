import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:union_player_app/ui/my_app_bar.dart';
import 'package:union_player_app/util/constants/constants.dart';
import 'package:union_player_app/util/localizations/app_localizations_delegate.dart';
import 'file:///C:/Users/lenak/AndroidStudioProjects/GeekBrainsProjects/player-master/lib/util/dimensions/dimensions.dart';
import '../ui/my_bottom_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

late Logger logger = Logger();

class ScheduleScreen extends StatefulWidget {
  bool _isPlaying;

  //При переходе на экран расписания передаем информацию, играет ли радио, чтобы отобразить правильный значок в аппбаре:
  ScheduleScreen({required bool isPlaying}):_isPlaying = isPlaying;

  @override
  createState() => ScheduleScreenState(isPlaying: _isPlaying);
}

class ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedIndex = 1;
  IconData _appBarIcon = Icons.play_arrow_rounded;
  bool _isPlaying = false;

  ScheduleScreenState({required bool isPlaying}) :_isPlaying = isPlaying;

  List<ProgramListItem> _array = [
    ProgramListItem(
        "Утренняя зарядка", "Благородные стремления не спасут: жизнь прекрасна",
        "12:00",
        imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRygBKRZC_XhwMXnmXT-Wq_8TGT4MSkV3KY-A&usqp=CAU"),
    ProgramListItem("Угадай страну",
        "Повседневная практика показывает, что высокое качество позиционных исследований говорит о возможностях системы массового участия.",
        "15:00",
        imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsh0I61KOzNAOzvjEmMUKjmH9EZwxB2UGovg&usqp=CAU"),
    ProgramListItem("О, радио!",
        "Свободу слова не задушить, пусть даже средства индивидуальной защиты оказались бесполезны",
        "15:30",
        imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhUkOp_uSZY5R2gsHMxKt6nTIy-isvdm7pxQ&usqp=CAU"),
    ProgramListItem(
        "Играй, гармонь", "Сложно сказать, почему склады ломятся от зерна",
        "16:15",
        imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRWS-O75WhJE-wnol-9NfBr54rmbsUc0LeDA&usqp=CAU"),
    ProgramListItem("Новости",
        "Каждый из нас понимает очевидную вещь: повышение уровня гражданского сознания требует определения и уточнения соответствующих условий активизации.",
        "17:00"),
    ProgramListItem("Ночь оказалась долгой",
        "И по сей день в центральных регионах звучит перекатами старческий скрип Амстердама.",
        "18:00",
        imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoydUqpTZ-TQ2h-IDrwIwuQjtWd44w2IXPWQ&usqp=CAU")
  ];

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
                            itemCount: _array.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _array[index];
                            }
                        )),
                    bottomNavigationBar: MyBottomNavigationBar(
                        _selectedIndex, _onBottomMenuItemTapped)
                ))

    );
  }
}

class ProgramListItem extends StatelessWidget {
  final String _title;
  final String _text;
  final String _startTime;
  late String? _imageUrl;

  ProgramListItem(this._title, this._text, this._startTime, {@required String? imageUrl}) {
    _imageUrl = imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    late Image image;
    if (_imageUrl != null && _imageUrl != '') image = Image.network(_imageUrl!, width: scheduleImageSide, height: scheduleImageSide, fit: BoxFit.cover);
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
                    Expanded(child: Text(_title, style: TextStyle(fontSize: titleFontSize), softWrap: true, textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                    Text(_startTime,  style: TextStyle(fontSize: titleFontSize), overflow: TextOverflow.ellipsis),
                  ]),
                  Container(
                      padding: programBodyTopPadding,
                      alignment: Alignment.centerLeft,
                      child: Text(_text, style: TextStyle(fontSize: bodyFontSize), softWrap: true, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, maxLines: 3,))
                ])
            )
        )
      ])
    );
  }
}
