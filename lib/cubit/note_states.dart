import 'package:notes_api/notes_api.dart';

import '../models/note_model.dart';

abstract class NoteState {}

class InitNoteState extends NoteState {}

class GetAllNotesState extends NoteState {
  final List<Note> notes;

  GetAllNotesState(this.notes);
}

class AddNoteState extends NoteState {}

class UpdateNoteState extends NoteState {}

class DeleteNoteState extends NoteState {}

class FailureNoteState extends NoteState {}
