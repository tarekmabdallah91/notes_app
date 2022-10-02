part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

class StatsState extends Equatable {
  const StatsState({
    this.status = StatsStatus.initial,
    this.completedNotes = 0,
    this.activeNotes = 0,
  });

  final StatsStatus status;
  final int completedNotes;
  final int activeNotes;

  @override
  List<Object> get props => [status, completedNotes, activeNotes];

  StatsState copyWith({
    StatsStatus? status,
    int? completedNotes,
    int? activeNotes,
  }) {
    return StatsState(
      status: status ?? this.status,
      completedNotes: completedNotes ?? this.completedNotes,
      activeNotes: activeNotes ?? this.activeNotes,
    );
  }
}
