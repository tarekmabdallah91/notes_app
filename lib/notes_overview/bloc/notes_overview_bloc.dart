import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/utils/text_utils.dart';
import 'package:notes_repository/note_repository.dart';
import 'package:remote_storage_notes_api/remote_storage_notes_api.dart';

import '../models/notes_view_filter.dart';

part 'notes_overview_event.dart';
part 'notes_overview_state.dart';

class NotesOverviewBloc extends Bloc<NotesOverviewEvent, NotesOverviewState> {
  NotesOverviewBloc({
    required NotesRepository notesRepository,
    required RemoteRepository remoteRepository,
  })  : _notesRepository = notesRepository,
        _remoteRepository = remoteRepository,
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
  final RemoteRepository _remoteRepository;

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
    var newNote = event.note.copyWith(isArchived: event.isArchived);
    _saveArchivedNoteRemotly(newNote);
    await _notesRepository.saveNote(newNote);
  }

  void _saveArchivedNoteRemotly(Note note) async {
    if (note.isArchived) {
      _archiveNoteRemotly(note);
    } else {
      _removeArchivedNote(note);
    }
  }

  void _archiveNoteRemotly(Note note) async {
    final response = await _remoteRepository.saveNote(note);
    final remoteId = checkResponse(response);
    note = note.copyWith(remoteId: remoteId);
    TextUtils.printLog('remoteId', remoteId);
    TextUtils.printLog('onNoteArchivedToggled', note.toJson());
  }

  void _removeArchivedNote(Note note) async {
    checkResponse(await _remoteRepository.deleteNote(note.id, note.remoteId));
  }

  Future<void> _onNoteDeleted(
    NotesOverviewNoteDeleted event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(state.copyWith(lastDeletedNote: () => event.note));
    if (event.note.isArchived) _removeArchivedNote(event.note);
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
    if (note.isArchived) _archiveNoteRemotly(note);
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
    
    for (var note in state.notes) {
      if (note.isArchived) {
        _removeArchivedNote(note);
      } else {
        _archiveNoteRemotly(note);
      }
      note = note.copyWith(isArchived: !note.isArchived);
      await _notesRepository.saveNote(note);
    }
    // final areAllArchived = state.notes.every((note) => note.isArchived);
    //  await _notesRepository.archiveAll(isArchived: !areAllArchived);
  }

  Future<void> _onClearArchivedRequested(
    NotesOverviewClearArchivedRequested event,
    Emitter<NotesOverviewState> emit,
  ) async {
    checkResponse(await _remoteRepository.clearArchived());
    await _notesRepository.clearArchived();
  }

  String checkResponse(Response response) {
    if (response.data == null) return 'data is empty';
    TextUtils.printLog('checkResponse', response.data!);
    if (response.statusCode == HttpStatus.ok) {
      return (response.data['name']) as String;
    } else {
      return response.statusCode.toString();
    }
  }
}
