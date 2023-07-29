import 'package:equatable/equatable.dart';

import 'main_item_view.dart';

class MainState extends Equatable {
  final List<MainItemView> items;
  final int currentIndex;

  const MainState({
    this.items = const [],
    this.currentIndex = 0,
  });

  @override
  List<Object?> get props => [items, currentIndex];
}
