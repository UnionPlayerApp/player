import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';


class FeedbackPage extends StatefulWidget {
  final AppLogger _logger;

  FeedbackPage(this._logger);

  @override
  State<StatefulWidget> createState() {
    return FeedbackPageState(_logger);
  }
}

class FeedbackPageState extends State {
  final _formKey = GlobalKey<FormState>();
  final _webViewKey = UniqueKey();
  final AppLogger _logger;

  FeedbackPageState(this._logger);

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

  _aboutButtonPressed() async {
    String _url = await _getUrlFromAssets();
    // For testing:
    // String _url = "https://stackoverflow.com/questions/52414629/how-to-update-state-of-a-modalbottomsheet-in-flutter";
    int indexedStackPosition = 1 ;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          Set<Factory<OneSequenceGestureRecognizer>> _gestureRecognizers = [Factory(() => EagerGestureRecognizer())].toSet();
          // Use StatefulBuilder in order to change state of bottomSheet:
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState ) {
                return
                  IndexedStack(
                      index: indexedStackPosition,
                      children: <Widget>[
                        WebView(
                          key: _webViewKey,
                          initialUrl: _url,
                          javascriptMode: JavascriptMode.unrestricted,
                          gestureRecognizers: _gestureRecognizers,
                          onPageStarted: (value){
                            _logger.logDebug("Loading about_page started...");
                            setState(() {
                              indexedStackPosition = 1;
                            });},
                          onPageFinished: (value) {
                            _logger.logDebug("Loading about_page finished!");
                            // Hide loading indicator:
                            setState(() {
                              indexedStackPosition = 0;
                            });
                          },
                        ),
                        Container(
                          child: Center(
                              child: CircularProgressIndicator()),
                        ),
                    ]);
        });
        });
  }

  Future<String> _getUrlFromAssets()  async {
    String fileText = await rootBundle.loadString('assets/about_us_page/test_page.html');
    String url = Uri.dataFromString(
    fileText,
    mimeType: 'text/html',
    encoding: Encoding.getByName('utf-8')).toString();
    return url;
  }


  _sendButtonPressed(){
    if (_formKey.currentState!.validate()) {
      String text =
      translate(StringKeys.formSuccessText, context);
      Color color = Colors.green;
      // Для использования Scaffold.of(context) я создала внутренний BuildContext - см. коммент выше,
      // т.к. аргумент context не может использоваться для поиска Scaffold, если он находится "выше" в дереве виджетов.
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(text), backgroundColor: color));
    }
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
                  padding: EdgeInsets.only(top: 15.h, right: 10.w),
                  child:
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         TextButton(
                             onPressed: _aboutButtonPressed,
                             child: Text(translate(StringKeys.aboutButtonText, context)),
                         ),
                         Padding(
                           padding: EdgeInsets.only(left: 15.w),
                           child:
                           ElevatedButton(
                            onPressed: _sendButtonPressed,
                            child: Text(translate(StringKeys.sendButtonText, context)),
                          )
                         ),
                      ],
                     ),
                ),
              ],
            )));
  }
}
