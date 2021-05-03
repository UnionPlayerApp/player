import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:logger/logger.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

late Logger logger = Logger();

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State {
  final _formKey = GlobalKey<FormState>();

  _createTextFormField(
      String label, String hint, FieldValidator formValidator) {
    return TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: label, hintText: hint),
        keyboardType: TextInputType.multiline,
        minLines: 1,
        //Normal textInputField will be displayed
        maxLines: 5,
        validator: formValidator);
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: allSidesMargin,
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: textFormFieldPadding,
                    child: _createTextFormField(
                        translate(StringKeys.nameFormTitle, context),
                        translate(StringKeys.nameFormHint, context),
                        MultiValidator([
                          RequiredValidator(
                              errorText: translate(
                                  StringKeys.requiredErrorText, context)),
                        ]))),
                Padding(
                    padding: textFormFieldPadding,
                    child: _createTextFormField(
                        translate(StringKeys.emailFormTitle, context),
                        translate(StringKeys.emailFormHint, context),
                        MultiValidator([
                          RequiredValidator(
                              errorText: translate(
                                  StringKeys.requiredErrorText, context)),
                          EmailValidator(
                              errorText: translate(
                                  StringKeys.emailErrorText, context)),
                        ]))),
                Padding(
                    padding: textFormFieldPadding,
                    child: _createTextFormField(
                        translate(StringKeys.phoneFormTitle, context),
                        translate(StringKeys.phoneFormHint, context),
                        MultiValidator([
                          RequiredValidator(
                              errorText: translate(
                                  StringKeys.requiredErrorText, context)),
                          PatternValidator(PHONE_PATTERN,
                              errorText:
                              translate(StringKeys.phoneErrorText, context))
                        ]))),
                Padding(
                    padding: textFormFieldPadding,
                    child: _createTextFormField(
                        translate(StringKeys.messageFormTitle, context),
                        translate(StringKeys.messageFormHint, context),
                        MultiValidator([
                          RequiredValidator(
                              errorText: translate(
                                  StringKeys.requiredErrorText, context)),
                          MaxLengthValidator(MAX_MESSAGE_LENGTH,
                              errorText: translate(
                                  StringKeys.messageMaxLengthError, context))
                        ]))),
                Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String text =
                        translate(StringKeys.formSuccessText, context);
                        Color color = Colors.green;
                        // Для использования Scaffold.of(context) я создала внутренний BuildContext - см. коммент выше,
                        // т.к. аргумент context не может использоваться для поиска Scaffold, если он находится "выше" в дереве виджетов.
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(text), backgroundColor: color));
                      }
                    },
                    child: Text(translate(StringKeys.sendButtonText, context)),
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                ),
              ],
            )));
  }
}
