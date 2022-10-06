part of 'notes_overview_cubit.dart';

enum NotesOverviewStatus { initial, loading, success, failure }

class NotesOverviewState extends Equatable {
  const NotesOverviewState({
    this.status = NotesOverviewStatus.initial,
    this.notes = const [],
    this.filter = NotesViewFilter.all,
    this.lastDeletedNote,
  });

  final NotesOverviewStatus status;
  final List<Note> notes;
  final NotesViewFilter filter;
  final Note? lastDeletedNote;

  Iterable<Note> get filteredNotes => filter.applyAll(notes);

  NotesOverviewState copyWith({
    NotesOverviewStatus ? status,
    List<Note> ? notes,
    NotesViewFilter ? filter,
    Note? lastDeletedNote,
  }) {
    return NotesOverviewState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      filter: filter ?? this.filter,
      lastDeletedNote: lastDeletedNote ?? this.lastDeletedNote,
    );
  }

  @override
  List<Object?> get props => [
        status,
        notes,
        filter,
        lastDeletedNote,
      ];
}
