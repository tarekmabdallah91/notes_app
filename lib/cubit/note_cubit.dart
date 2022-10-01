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

  @override
  void onChange(Change<NoteState> change) {
    super.onChange(change);
    TextUtils.printLog('NoteCubit onChange', '$change');
  }

  void addNote(NoteModel noteModel) async {
    try {
      await _notesDb.addNote(noteModel);
      int index = getNoteIndexFromNotesList(noteModel);
      if (index >= 0) {
        TextUtils.printLog(tag, 'index = $index');
        notes[index] = noteModel;
        emit(UpdateNoteState());
      } else {
        notes.add(noteModel);
        emit(AddNoteState());
      }
    } on Exception catch (error) {
      _handleExpections(error);
    }
  }

  int getNoteIndexFromNotesList(NoteModel noteModel) {
    return notes.indexWhere((element) => element.id == noteModel.id);
  }

  Future<void> getAllNotes() async {
    TextUtils.printLog(tag, 'getAllNotes Cubit');
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

  NoteModel? getNoteById(String noteId) {
    try {
      return notes.firstWhere((element) => element.id == noteId);
    } on Exception catch (error) {
      _handleExpections(error);
      return null;
    }
  }

  void deleteNote(String id) async {
    try {
      await _notesDb.deleteNote(id);
      emit(DeleteNoteState());
    } on Exception catch (error) {
      _handleExpections(error);
    }
  }

  void _handleExpections(Exception exception) {
    TextUtils.printLog(tag, exception);
    emit(FailureNoteState());
  }
}
