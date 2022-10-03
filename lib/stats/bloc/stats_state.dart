part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

class StatsState extends Equatable {
  const StatsState({
    this.status = StatsStatus.initial,
    this.archivedNotes = 0,
    this.activeNotes = 0,
  });

  final StatsStatus status;
  final int archivedNotes;
  final int activeNotes;

  @override
  List<Object> get props => [status, archivedNotes, activeNotes];

  StatsState copyWith({
    StatsStatus? status,
    int? archivedNotes,
    int? activeNotes,
  }) {
    return StatsState(
      status: status ?? this.status,
      archivedNotes: archivedNotes ?? this.archivedNotes,
      activeNotes: activeNotes ?? this.activeNotes,
    );
  }
}
