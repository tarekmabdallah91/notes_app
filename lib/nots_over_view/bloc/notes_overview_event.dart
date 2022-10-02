part of 'notes_overview_bloc.dart';

abstract class NotesOverviewEvent extends Equatable {
  const NotesOverviewEvent();

  @override
  List<Object> get props => [];
}

class NotesOverviewSubscriptionRequested extends NotesOverviewEvent {
  const NotesOverviewSubscriptionRequested();
}

class NotesOverviewNoteCompletionToggled extends NotesOverviewEvent {
  const NotesOverviewNoteCompletionToggled({
    required this.note,
    required this.isArchived,
  });

  final Note note;
  final bool isArchived;

  @override
  List<Object> get props => [note, isArchived];
}

class NotesOverviewNoteDeleted extends NotesOverviewEvent {
  const NotesOverviewNoteDeleted(this.note);

  final Note note;

  @override
  List<Object> get props => [note];
}

class NotesOverviewUndoDeletionRequested extends NotesOverviewEvent {
  const NotesOverviewUndoDeletionRequested();
}

class NotesOverviewFilterChanged extends NotesOverviewEvent {
  const NotesOverviewFilterChanged(this.filter);

  final NotesViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class NotesOverviewToggleAllRequested extends NotesOverviewEvent {
  const NotesOverviewToggleAllRequested();
}

class NotesOverviewClearCompletedRequested extends NotesOverviewEvent {
  const NotesOverviewClearCompletedRequested();
}