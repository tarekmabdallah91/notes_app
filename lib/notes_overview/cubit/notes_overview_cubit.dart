import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/utils/text_utils.dart';
import 'package:notes_repository/note_repository.dart';
import 'package:remote_storage_notes_api/remote_storage_notes_api.dart';
import '../models/notes_view_filter.dart';

part 'notes_overview_state.dart';

class NotesOverviewCubit extends Cubit<NotesOverviewState> {
  NotesOverviewCubit({
    required NotesRepository notesRepository,
    required RemoteRepository remoteRepository,
  })  : _notesRepository = notesRepository,
        _remoteRepository = remoteRepository,
        super(const NotesOverviewState()) {
    getAllNotes();
  }

  final NotesRepository _notesRepository;
  final RemoteRepository _remoteRepository;

  void getAllNotes() async {
    emit(state.copyWith(status: NotesOverviewStatus.loading));
    _notesRepository.getNotes().listen(
          (notes) {
            emit(state.copyWith(
            status: NotesOverviewStatus.success,
            notes: notes,
          ));
          },
          onError: (_, __) => state.copyWith(
            status: NotesOverviewStatus.failure,
          ),
        );
  }

  void onNoteArchivedToggled(
      {required Note note, required bool isArchived}) async {
    var newNote = note.copyWith(isArchived: isArchived);
    _saveArchivedNoteRemotly(newNote);
    await _notesRepository.saveNote(newNote);
  }

  void _saveArchivedNoteRemotly(Note note) {
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

  void onNoteDeleted(Note note) async {
    emit(state.copyWith(lastDeletedNote: note));
    if (note.isArchived) _removeArchivedNote(note);
    await _notesRepository.deleteNote(note.id);
  }

  void onUndoDeletionRequested() async {
    assert(
      state.lastDeletedNote != null,
      'Last deleted Note can not be null.',
    );

    final note = state.lastDeletedNote!;
    emit(state.copyWith(lastDeletedNote: null));
    if (note.isArchived) _archiveNoteRemotly(note);
    await _notesRepository.saveNote(note);
  }

  void onFilterChanged(NotesViewFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  void onToggleAllRequested() async {
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

  void onClearArchivedRequested() async {
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
