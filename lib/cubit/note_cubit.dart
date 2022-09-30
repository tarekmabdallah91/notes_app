import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/note_states.dart';
import 'package:notes_app/data/sql/notes_db.dart';
import 'package:notes_app/models/note_model.dart';

import '../utils/text_utils.dart';

class NoteCubit extends Cubit<NoteState> {
  final tag = 'NoteCubit';
  NoteCubit() : super(InitNoteState());

  final NotesDb _notesDb = NotesDb();
  List<NoteModel> notes = [];
  NoteModel? noteModel;

  void addNote(NoteModel noteModel) async {
    try {
      await _notesDb.addNote(noteModel);
      getAllNotes();
    } on Exception catch (error) {
      _handleExpections(error);
    }
  }

  Future<void> getAllNotes() async {
    emit(InitNoteState());
    try {
      final notesListInDb = await _notesDb.getAllNotes();
      notes = notesListInDb.toList();
      TextUtils.printLog(tag, 'notes = ${notes.length}');
      emit(GetAllNotesState());
    } on Exception catch (error) {
      _handleExpections(error);
    }
  }

  Future<void> getNoteById(String noteId) async {
    emit(InitNoteState());
    try {
      final noteInDb = await _notesDb.getNoteById(noteId);
      TextUtils.printLog(tag, 'getNoteById notes = ${noteInDb.title}');
      noteModel = noteInDb;
      // emit(GetNoteByIdState(noteInDb));
    } on Exception catch (error) {
      _handleExpections(error);
    }
  }

  void deleteNote(String id) async {
    try {
      await _notesDb.deleteNote(id);
      getAllNotes();
    } on Exception catch (error) {
      _handleExpections(error);
    }
  }

  void _handleExpections(Exception exception) {
    TextUtils.printLog(tag, exception);
    emit(FailureNoteState());
  }
}
