import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:union_player_app/ui/my_app_bar.dart';
import 'package:union_player_app/ui/my_bottom_navigation_bar.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:union_player_app/util/constants/constants.dart';
import 'file:///C:/Users/lenak/AndroidStudioProjects/GeekBrainsProjects/player-master/lib/util/dimensions/dimensions.dart';
import 'package:union_player_app/util/localizations/app_localizations_delegate.dart';
import 'package:union_player_app/util/localizations/string_translation.dart';


late Logger logger = Logger();

void main() {
  runApp(FeedbackScreen(isPlaying: true));
}

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
      logger.d("$LOG_TAG +  Bottom navigation selected item index: $_selectedIndex");
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
        designSize: Size(prototypeDeviceWidth, prototypeDeviceHeight),
        builder: () => MaterialApp(
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
              body: Builder(
              // Создает внутренний BuildContext, чтобы в методе onPressed
              // можно было сылаться на Scaffold в Scaffold.of(BuildContext context)
              // Подробнее: https://api.flutter.dev/flutter/material/Scaffold/of.html
              builder: (BuildContext context) {
                return SingleChildScrollView(
                    padding: allSidesMargin,
                    child:
                    Form(
                        key: _formKey,
                        child: Column(children:
                        <Widget>[

                          Padding(
                              padding: textFormFieldPadding,
                              child: _createTextFormField(
                                  translate(StringKeys.nameFormTitle, context),
                                  translate(StringKeys.nameFormHint, context),
                                  MultiValidator([
                                    RequiredValidator(errorText: translate(StringKeys.requiredErrorText, context)),
                                  ])
                              )),

                          Padding(
                              padding: textFormFieldPadding,
                              child: _createTextFormField(
                                  translate(StringKeys.emailFormTitle, context),
                                  translate(StringKeys.emailFormHint, context),
                                  MultiValidator([
                                    RequiredValidator(errorText: translate(StringKeys.requiredErrorText, context)),
                                    EmailValidator(
                                        errorText: translate(StringKeys.emailErrorText, context)),
                                  ])
                              )),

                          Padding(
                              padding: textFormFieldPadding,
                              child: _createTextFormField(
                                  translate(StringKeys.phoneFormTitle, context),
                                  translate(StringKeys.phoneFormHint, context),
                                  MultiValidator([
                                    RequiredValidator(errorText: translate(StringKeys.requiredErrorText, context)),
                                    PatternValidator(
                                        phonePattern,
                                        errorText: translate(StringKeys.phoneErrorText, context))
                                  ])
                              )),

                          Padding(
                              padding: textFormFieldPadding,
                              child: _createTextFormField(
                                  translate(StringKeys.messageFormTitle, context),
                                  translate(StringKeys.messageFormHint, context),
                                  MultiValidator([
                                    RequiredValidator(errorText: translate(StringKeys.requiredErrorText, context)),
                                    MaxLengthValidator(maxMessageLength,
                                        errorText: translate(StringKeys.messageMaxLengthError, context))
                                  ])
                              )),

                          Padding(
                            padding: EdgeInsets.only(top: 15.h),
                            child:
                            RaisedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  String text = translate(StringKeys.formSuccessText, context);
                                  Color color = Colors.green;
                                  // Для использования Scaffold.of(context) я создала внутренний BuildContext - см. коммент выше,
                                  // т.к. аргумент context не может использоваться для поиска Scaffold, если он находится "выше" в дереве виджетов.
                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text(text),
                                          backgroundColor: color));
                                }
                              },
                              child: Text(translate(StringKeys.sendButtonText, context)),
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
