import 'package:notes_api/notes_api.dart';


/// {@template Notes_repository}
/// A repository that handles Note related requests.
/// {@endtemplate}
class NotesRepository {
  /// {@macro Notes_repository}
  const NotesRepository({
    required NotesApi NotesApi,
  }) : _NotesApi = NotesApi;

  final NotesApi _NotesApi;

  /// Provides a [Stream] of all Notes.
  Stream<List<Note>> getNotes() => _NotesApi.getNotes();

  /// Saves a [Note].
  ///
  /// If a [Note] with the same id already exists, it will be replaced.
  Future<void> saveNote(Note Note) => _NotesApi.saveNote(Note);

  /// Deletes the Note with the given id.
  ///
  /// If no Note with the given id exists, a [NoteNotFoundException] error is
  /// thrown.
  Future<void> deleteNote(String id) => _NotesApi.deleteNote(id);

  /// Deletes all completed Notes.
  ///
  /// Returns the number of deleted Notes.
  // Future<int> clearCompleted() => _NotesApi.clearCompleted();

  // /// Sets the `isCompleted` state of all Notes to the given value.
  // ///
  // /// Returns the number of updated Notes.
  // Future<int> completeAll({required bool isCompleted}) =>
  //     _NotesApi.completeAll(isCompleted: isCompleted);
}
