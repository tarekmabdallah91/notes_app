import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';

class NoteProvider with ChangeNotifier {
  List<NoteModel> notes = [
    NoteModel(title: 'Note1', body: 'booooody1'),
    NoteModel(title: 'Note2', body: 'booooody2booooody2'),
    NoteModel(title: 'Note3', body: 'booooody3booooody3booooody3'),
    NoteModel(title: 'Note4', body: 'booooody4booooody4booooody4booooody4'),
    NoteModel(
        title: 'Note5', body: 'booooody5booooody5booooody5booooody5booooody5'),
  ];

  List<NoteModel> getNotes() => notes;

  void addNote(NoteModel noteModel) {
    notes.add(noteModel);
    notifyListeners();
  }
}
