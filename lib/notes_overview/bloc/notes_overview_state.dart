part of 'notes_overview_bloc.dart';

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
    NotesOverviewStatus Function()? status,
    List<Note> Function()? notes,
    NotesViewFilter Function()? filter,
    Note? Function()? lastDeletedNote,
  }) {
    return NotesOverviewState(
      status: status != null ? status() : this.status,
      notes: notes != null ? notes() : this.notes,
      filter: filter != null ? filter() : this.filter,
      lastDeletedNote:
          lastDeletedNote != null ? lastDeletedNote() : this.lastDeletedNote,
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
