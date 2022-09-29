import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/note_states.dart';
import 'package:notes_app/data/sql/notes_db.dart';
import 'package:notes_app/models/note_model.dart';

import '../utils/text_utils.dart';

class NoteCubit extends Cubit<NoteState> {
  final tag = 'NoteCubit';
  NoteCubit() : super(InitNoteState());

  final NotesDb _notesD = NotesDb();
  List<NoteModel> notes = [];

  void addNote(NoteModel noteModel) async {
    try {
      await _notesD.addNote(noteModel);
      getAllNotes();
    } on Exception catch (error) {
      _handleExpections(error);
    }
  }

  Future<void> getAllNotes() async {
    emit(InitNoteState());
    try {
      final notesListInDb = await _notesD.getAllNotes();
      notes = notesListInDb.toList();
      TextUtils.printLog(tag, 'notes = ${notes.length}');
      emit(GetAllNotesState());
    } on Exception catch (error) {
      _handleExpections(error);
    }
  }

  void deleteNote(String id) async {
    try {
      await _notesD.deleteNote(id);
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
