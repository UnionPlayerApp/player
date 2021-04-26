import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/navigation/bottom_navigation_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_page.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/screen_schedule/schedule_screen.dart';

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
              return ScheduleScreen(isPlaying: true);
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
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.radio, color: Colors.black),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.list_alt, color: Colors.black),
                        label: 'Schedule',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.markunread_mailbox_outlined,
                            color: Colors.black),
                        label: 'Feedback',
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
