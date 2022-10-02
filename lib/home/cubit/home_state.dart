part of 'home_cubit.dart';

enum HomeTab { notes, archive }

class HomeState extends Equatable {
  const HomeState({
    this.tab = HomeTab.notes,
  });

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}