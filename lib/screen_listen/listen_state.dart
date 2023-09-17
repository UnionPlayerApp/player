import 'package:equatable/equatable.dart';

import 'listen_item_view.dart';

class ListenState extends Equatable {
  final List<ListenItemView> items;
  final int currentIndex;

  const ListenState({
    this.items = const [],
    this.currentIndex = 0,
  });

  @override
  List<Object?> get props => [items, currentIndex];
}
