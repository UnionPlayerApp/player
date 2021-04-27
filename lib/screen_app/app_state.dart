part of 'app_bloc.dart';

class AppState extends Equatable {
  final int navIndex;
  final bool isPlaying;

  const AppState(this.navIndex, this.isPlaying);

  @override
  List<Object> get props => [navIndex, isPlaying];
}
