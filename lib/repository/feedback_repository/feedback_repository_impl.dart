import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:union_player_app/repository/feedback_repository/i_feedback_repository.dart';
import 'package:union_player_app/screen_feedback/feedback_state.dart';

class FeedbackRepositoryImpl implements IFeedbackRepository{
  static const String TEST_PAGE_PATH = 'assets/about_us_page/test_page.html';

  @override
  Future<FeedbackState> getAboutPageUrl() async{
    try {
      String fileText =
          await rootBundle.loadString(TEST_PAGE_PATH);
      String url = Uri.dataFromString(fileText,
          mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString();
      return AboutInfoLoadSuccessState(url);
    } catch (exception) {
      return AboutInfoLoadErrorState(exception.toString());
    }
  }
}