import '../models/note_model.dart';

abstract class NoteState {}

class InitNoteState extends NoteState {}

class GetAllNotesState extends NoteState {}

class GetNoteByIdState extends NoteState {
  final NoteModel selectedNoteModel;

  GetNoteByIdState(this.selectedNoteModel);
}

class FailureNoteState extends NoteState {}