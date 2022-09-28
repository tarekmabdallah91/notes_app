import 'package:flutter/foundation.dart';
import 'package:notes_app/models/note_model.dart';

import '../data/sql/notes_db.dart';

class NoteProvider with ChangeNotifier {
  List<NoteModel> notes = [];

  List<NoteModel> getNotes() {
    print('Notes count = ${notes.length}');
    return notes;
  }

  NotesDb notesDb = NotesDb();

  void addNote(NoteModel noteModel) {
    notes.add(noteModel);
    notifyListeners();
    notesDb.insert(noteModel);
  }

  void updateNote(NoteModel noteModel) {
    // notes.insert(noteModel.id!, noteModel);
    notesDb.updateNote(noteModel);
    notifyListeners();
  }

  Future<void> getAllNotes() async {
    // notes = [];
    final notesListInDb = await notesDb.getAllNotes();
    print('notes before adding = ${notesListInDb.length}');
    notes = notesListInDb.toList();
    print('all notes = ${notes.length}');
    notifyListeners(); // calling it make the UI rebuilt many times
  }

  NoteModel getNoteById(int id) {
    return notesDb.getNoteById(id) as NoteModel;
  }

  void deleteNote(String id) {
    // notes.removeAt(id);
    notesDb.deleteNote(id);
    notifyListeners();
  }
}
