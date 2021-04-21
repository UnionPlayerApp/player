import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/blocs/bottom_navigation/bottom_navigation_bloc.dart';
import 'package:union_player_app/ui/pages/feedback_page.dart';
import 'package:union_player_app/ui/pages/schedule_screen.dart';
import 'package:union_player_app/ui/pages/screen_main/main_bloc.dart';
import 'package:union_player_app/ui/pages/screen_main/main_page.dart';


class AppScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (BuildContext context, BottomNavigationState state) {
          if (state is PageLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is MainPageLoaded) {
            return BlocProvider(
                create: (context) => MainBloc(),
                child: MainPage(),
            );
          }
          if (state is SchedulePageLoaded) {
            return ScheduleScreen(
              isPlaying: true,
            );
          }
          if (state is FeedbackPageLoaded) {
            return FeedbackScreen(
              isPlaying: true,
            );
          }

          return Container();
        },
      ),
      bottomNavigationBar:
          BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
              builder: (BuildContext context, BottomNavigationState state) {
        return BottomNavigationBar(
          currentIndex:
              context.select((BottomNavigationBloc bloc) => bloc.currentIndex),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.radio, color: Colors.black),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:
                  Icon(Icons.list_alt, color: Colors.black),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon:
                  Icon(Icons.markunread_mailbox_outlined, color: Colors.black),
              label: 'Feedback',
            ),
          ],
          onTap: (index) => context
              .read<BottomNavigationBloc>()
              .add(PageTapped(index: index)),
        );
      }),
    );
  }
}
