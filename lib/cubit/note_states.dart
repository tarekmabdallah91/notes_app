import '../models/note_model.dart';

abstract class NoteState {}

class InitNoteState extends NoteState {}

class GetAllNotesState extends NoteState {}
class AddNoteState extends NoteState {}
class UpdateNoteState extends NoteState {}
class DeleteNoteState extends NoteState {}

class FailureNoteState extends NoteState {}