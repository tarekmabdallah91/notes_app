import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/note_states.dart';
import 'package:notes_app/data/sql/notes_db.dart';
import 'package:notes_app/models/note_model.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(InitNoteState());

  final NotesDb _notesD = NotesDb();
  List<NoteModel> notes = [];

  void addNote(NoteModel noteModel) async {
    try {
      await _notesD.insert(noteModel);
      emit(AddNoteState());
      getAllNotes();
    } on Exception catch (e) {
      emit(FailureNoteState());
    }
  }

  Future<void> getAllNotes() async {
    emit(InitNoteState());
    try {
      final notesListInDb = await _notesD.getAllNotes();
      notes = notesListInDb.toList();
      print('notes = ${notes.length}');
      emit(GetAllNotesState());
    } catch (error) {
      emit(FailureNoteState());
    }
  }
}
