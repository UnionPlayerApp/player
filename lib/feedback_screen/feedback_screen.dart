import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:union_player_app/ui/my_app_bar.dart';
import 'package:union_player_app/ui/my_bottom_navigation_bar.dart';
import 'package:form_field_validator/form_field_validator.dart';


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

  _createTextFormField(String label, String hint, FieldValidator formValidator){
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          hintText: hint),
        keyboardType: TextInputType.multiline,
        minLines: 1,//Normal textInputField will be displayed
        maxLines: 5,
        validator: formValidator);
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
              body: Builder(
              // Создает внутренний BuildContext, чтобы в методе onPressed
              // можно было сылаться на Scaffold в Scaffold.of(BuildContext context)
              // Подробнее: https://api.flutter.dev/flutter/material/Scaffold/of.html
              builder: (BuildContext context) {
                return SingleChildScrollView(
                    padding: EdgeInsets.all(10.h),
                    child:
                    Form(
                        key: _formKey,
                        child: Column(children:
                        <Widget>[

                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w) +
                                  EdgeInsets.only(top: 15.h),
                              child: _createTextFormField(
                                  'Your name',
                                  'Please, enter your name here',
                                  MultiValidator([
                                    RequiredValidator(errorText: "* Required"),
                                  ])
                              )),

                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w) +
                                  EdgeInsets.only(top: 15.h),
                              child: _createTextFormField(
                                  'Email',
                                  'Enter valid email id as abc@gmail.com',
                                  MultiValidator([
                                    RequiredValidator(errorText: "* Required"),
                                    EmailValidator(
                                        errorText: "Enter valid email id"),
                                  ])
                              )),

                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w) +
                                  EdgeInsets.only(top: 15.h),
                              child: _createTextFormField(
                                  'Your phone',
                                  'Please, enter your phone number',
                                  MultiValidator([
                                    RequiredValidator(errorText: "* Required"),
                                    PatternValidator(
                                        r'(^(?:[+0]9)?[0-9]{10,12}$)',
                                        errorText: "Number entered incorrectly")
                                  ])
                              )),

                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w) +
                                  EdgeInsets.only(top: 15.h),
                              child: _createTextFormField(
                                  'Your message',
                                  'Please, write something here',
                                  MultiValidator([
                                    RequiredValidator(errorText: "* Required"),
                                    MaxLengthValidator(400,
                                        errorText: "The length of the message cannot exceed 400 characters")
                                  ])
                              )),

                          Padding(
                            padding: EdgeInsets.only(top: 15.h),
                            child:
                            RaisedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  String text = "Форма успешно заполнена";
                                  Color color = Colors.green;
                                  // Для использования Scaffold.of(context) я создала внутренний BuildContext - см. коммент выше,
                                  // т.к. аргумент context не может использоваться для поиска Scaffold, если он находится "выше" в дереве виджетов.
                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text(text),
                                          backgroundColor: color));
                                }
                              },
                              child: Text('Отправить'),
                              color: Colors.blue,
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                        )
                    )
                );
              }
              ),
               bottomNavigationBar: MyBottomNavigationBar(_selectedIndex, _onBottomMenuItemTapped),
        )));
  }

}
