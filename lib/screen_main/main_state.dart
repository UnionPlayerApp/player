import 'package:equatable/equatable.dart';

class MainState extends Equatable {
  final bool isArtistVisible;
  final String itemLabel;
  final String itemTitle;
  final String itemArtist;

  const MainState(
      {this.isArtistVisible = false,
      this.itemLabel = "",
      this.itemTitle = "",
      this.itemArtist = ""});

  @override
  List<Object?> get props =>
      [isArtistVisible, itemLabel, itemTitle, itemArtist];
}
