import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:union_player_app/app/my_app_bar.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/localizations/app_localizations.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';


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

  FeedbackScreenState({required bool isPlaying}):_isPlaying = isPlaying;

  void _onButtonAppBarTapped(){
    _isPlaying = !_isPlaying;
    setState(() {
      if(_isPlaying) _appBarIcon = Icons.pause_rounded;
      else _appBarIcon =  Icons.play_arrow_rounded;
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
    BuildContext translationContext = context;
    return MaterialApp(
       debugShowCheckedModeBanner: false,
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
                              translate(StringKeys.nameFormTitle, translationContext),
                              translate(StringKeys.nameFormHint, translationContext),
                              MultiValidator([
                                RequiredValidator(errorText: translate(StringKeys.requiredErrorText, translationContext)),
                              ])
                          )),

                      Padding(
                          padding: textFormFieldPadding,
                          child: _createTextFormField(
                              translate(StringKeys.emailFormTitle, translationContext),
                              translate(StringKeys.emailFormHint, translationContext),
                              MultiValidator([
                                RequiredValidator(errorText: translate(StringKeys.requiredErrorText, translationContext)),
                                EmailValidator(
                                    errorText: translate(StringKeys.emailErrorText, translationContext)),
                              ])
                          )),

                      Padding(
                          padding: textFormFieldPadding,
                          child: _createTextFormField(
                              translate(StringKeys.phoneFormTitle, translationContext),
                              translate(StringKeys.phoneFormHint, translationContext),
                              MultiValidator([
                                RequiredValidator(errorText: translate(StringKeys.requiredErrorText, translationContext)),
                                PatternValidator(
                                    phonePattern,
                                    errorText: translate(StringKeys.phoneErrorText, translationContext))
                              ])
                          )),

                      Padding(
                          padding: textFormFieldPadding,
                          child: _createTextFormField(
                              translate(StringKeys.messageFormTitle, translationContext),
                              translate(StringKeys.messageFormHint, translationContext),
                              MultiValidator([
                                RequiredValidator(errorText: translate(StringKeys.requiredErrorText, translationContext)),
                                MaxLengthValidator(maxMessageLength,
                                    errorText: translate(StringKeys.messageMaxLengthError, translationContext))
                              ])
                          )),

                      Padding(
                        padding: EdgeInsets.only(top: 15.h),
                        child:
                        RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              String text = translate(StringKeys.formSuccessText, translationContext);
                              Color color = Colors.green;
                              // Для использования Scaffold.of(context) я создала внутренний BuildContext - см. коммент выше,
                              // т.к. аргумент context не может использоваться для поиска Scaffold, если он находится "выше" в дереве виджетов.
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text(text),
                                      backgroundColor: color));
                            }
                          },
                          child: Text(translate(StringKeys.sendButtonText, translationContext)),
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
    )
    );
  }

}
