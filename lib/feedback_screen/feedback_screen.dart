import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:union_player_app/ui/my_app_bar.dart';
import 'package:union_player_app/ui/my_bottom_navigation_bar.dart';

const LOG_TAG = "UPA -> ";
late Logger logger = Logger();

class FeedbackScreen extends StatefulWidget {
  bool _isPlaying;

  FeedbackScreen({required bool isPlaying}):_isPlaying = isPlaying;

  @override
  State<StatefulWidget> createState(){
    return FeedbackScreenState(isPlaying: _isPlaying);
  }
}

class FeedbackScreenState extends State {
  final _formKey = GlobalKey<FormState>();
  IconData _appBarIcon =  Icons.play_arrow_rounded;
  bool _isPlaying = false;
  int _selectedIndex = 2;

  FeedbackScreenState({required bool isPlaying}):_isPlaying = isPlaying;

  void _onButtonAppBarTapped(){
    _isPlaying = !_isPlaying;
    setState(() {
      if(_isPlaying) _appBarIcon = Icons.pause_rounded;
      else _appBarIcon =  Icons.play_arrow_rounded;
    });
  }

  void _onBottomMenuItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      logger.d("$LOG_TAG Bottom navigation selected item index: $_selectedIndex");
    });
  }

  Widget build(BuildContext context) {
    // Пока нет навигции между экранами и тестовый запуск экрана осуществляется через прямой вызов его в main,
    // инициализирую ScreenUtil в билдере каждого экрана, позже достаточно будет сделать это в билдере MyApp:
    return ScreenUtilInit(
        designSize: Size(390, 780),
        builder: () => MaterialApp(
           debugShowCheckedModeBanner: false,
           home: Scaffold(
              appBar: MyAppBar(_onButtonAppBarTapped, _appBarIcon),
              body: SingleChildScrollView(padding: EdgeInsets.all(10.h),
                  child:
                   Form(
                      key: _formKey,
                      child: Column(children:
                      <Widget>[
                        Text('Ваше имя:', style: TextStyle(fontSize: 20.0),),
                        TextFormField(validator: (value){
                          if (value!.isEmpty) return 'Пожалуйста, введите свое имя';
                        }),

                        SizedBox(height: 20.h),

                        Text('Контактный E-mail:', style: TextStyle(fontSize: 20.0),),
                        TextFormField(validator: (value){
                          if (value!.isEmpty) return 'Пожалуйста, введите свой Email';
                          String p = "[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+";
                          RegExp regExp = RegExp(p);
                          if (regExp.hasMatch(value)) return null;
                          return 'Неверно введен E-mail';
                        }),

                        SizedBox(height: 20.h),

                        Text('Контактный телефон:', style: TextStyle(fontSize: 20.0),),
                        TextFormField(validator: (value){
                          if (value!.isEmpty) return 'Пожалуйста, введите свой номер телефона';
                          String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          RegExp regExp = RegExp(pattern);
                          if (regExp.hasMatch(value)) return null;
                          return 'Неверно введен номер';
                        }),

                        SizedBox(height: 20.h),

                        Text('Текст обращения:', style: TextStyle(fontSize: 20.0),),
                        TextFormField(validator: (value){
                          if (value!.isEmpty) return 'Напишите нам';
                          if (value.length <= 400) return null;
                          return 'Длина сообщения не должна превышать 400 символов';
                        }),

                        SizedBox(height: 20.h),

                        RaisedButton(onPressed: () {
                          late String text;
                          late Color color;
                          if (_formKey.currentState!.validate()) {
                            text = "Форма успешно заполнена";
                            color = Colors.green;
                            }
                          Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(text), backgroundColor: color,));
                          },
                          child: Text('Отправить'), color: Colors.blue, textColor: Colors.white,
                        ),
                      ],
                      )
                    )
              ),
             bottomNavigationBar: MyBottomNavigationBar(_selectedIndex, _onBottomMenuItemTapped),

           ))
    );
  }
}
