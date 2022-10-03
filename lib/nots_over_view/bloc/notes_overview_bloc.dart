import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_repository/note_repository.dart';

import '../models/notes_view_filter.dart';

part 'notes_overview_event.dart';
part 'notes_overview_state.dart';

class NotesOverviewBloc extends Bloc<NotesOverviewEvent, NotesOverviewState> {
  NotesOverviewBloc({
    required NotesRepository notesRepository,
  })  : _notesRepository = notesRepository,
        super(const NotesOverviewState()) {
    on<NotesOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<NotesOverviewNoteArchivedToggled>(_onNoteArchivedToggled);
    on<NotesOverviewNoteDeleted>(_onNoteDeleted);
    on<NotesOverviewUndoDeletionRequested>(_onUndoDeletionRequested);
    on<NotesOverviewFilterChanged>(_onFilterChanged);
    on<NotesOverviewToggleAllRequested>(_onToggleAllRequested);
    on<NotesOverviewClearArchivedRequested>(_onClearArchivedRequested);
  }

  final NotesRepository _notesRepository;

  Future<void> _onSubscriptionRequested(
    NotesOverviewSubscriptionRequested event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => NotesOverviewStatus.loading));

    await emit.forEach<List<Note>>(
      _notesRepository.getNotes(),
      onData: (notes) => state.copyWith(
        status: () => NotesOverviewStatus.success,
        notes: () => notes,
      ),
      onError: (_, __) => state.copyWith(
        status: () => NotesOverviewStatus.failure,
      ),
    );
  }

  Future<void> _onNoteArchivedToggled(
    NotesOverviewNoteArchivedToggled event,
    Emitter<NotesOverviewState> emit,
  ) async {
    final newNote = event.note.copyWith(isArchived: event.isArchived);
    await _notesRepository.saveNote(newNote);
  }

  Future<void> _onNoteDeleted(
    NotesOverviewNoteDeleted event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(state.copyWith(lastDeletedNote: () => event.note));
    await _notesRepository.deleteNote(event.note.id);
  }

  Future<void> _onUndoDeletionRequested(
    NotesOverviewUndoDeletionRequested event,
    Emitter<NotesOverviewState> emit,
  ) async {
    assert(
      state.lastDeletedNote != null,
      'Last deleted Note can not be null.',
    );

    final note = state.lastDeletedNote!;
    emit(state.copyWith(lastDeletedNote: () => null));
    await _notesRepository.saveNote(note);
  }

  void _onFilterChanged(
    NotesOverviewFilterChanged event,
    Emitter<NotesOverviewState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }

  Future<void> _onToggleAllRequested(
    NotesOverviewToggleAllRequested event,
    Emitter<NotesOverviewState> emit,
  ) async {
    final areAllArchived = state.notes.every((note) => note.isArchived);
    await _notesRepository.archiveAll(isArchived: !areAllArchived);
  }

  Future<void> _onClearArchivedRequested(
    NotesOverviewClearArchivedRequested event,
    Emitter<NotesOverviewState> emit,
  ) async {
    await _notesRepository.clearArchived();
  }
}
