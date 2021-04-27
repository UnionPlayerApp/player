import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/navigation/bottom_navigation_bloc.dart';
import 'package:union_player_app/repository/schedule_repository.dart';
import 'package:union_player_app/screen_feedback/feedback_screen.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/screen_schedule/schedule_screen.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class BottomNavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (BuildContext context, BottomNavigationState state) {
          switch (state.currentIndex) {
            case 0:
              return BlocProvider(
                  create: (context) => get<MainBloc>(), child: get<MainPage>());
            case 1:
              return ScheduleScreen(ScheduleRepository(), true);
            case 2:
              return FeedbackScreen(isPlaying: true);
            default:
              return Container();
          }
        },
      ),
      bottomNavigationBar:
          BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
              builder: (BuildContext context, BottomNavigationState state) =>
                  BottomNavigationBar(
                    currentIndex: state.currentIndex,
                    selectedItemColor: Colors.red[800],
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.radio),
                        label: translate(StringKeys.home, context),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.list_alt),
                        label: translate(StringKeys.schedule, context),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.markunread_mailbox_outlined),
                        label:  translate(StringKeys.feedback, context),
                      ),
                    ],
                    onTap: (index) {
                      return context
                          .read<BottomNavigationBloc>()
                          .add(BottomNavigationEvent(index));
                    },
                  )),
    );
  }
}
