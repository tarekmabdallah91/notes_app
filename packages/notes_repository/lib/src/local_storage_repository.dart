import 'package:notes_api/notes_api.dart';

/// {@template Notes_repository}
/// A repository that handles Note related requests.
/// {@endtemplate}
class NotesRepository {
  /// {@macro Notes_repository}
  const NotesRepository({
    required NotesApi notesApi,
  }) : _notesApi = notesApi;

  final NotesApi _notesApi;

  /// Provides a [Stream] of all Notes.
  Stream<List<Note>> getNotes() => _notesApi.getNotes();

  /// Saves a [note].
  /// If a [note] with the same id already exists, it will be replaced.
  Future<void> saveNote(Note note) => _notesApi.saveNote(note);

  /// Deletes the Note with the given id.
  /// If no Note with the given id exists, a [NoteNotFoundException] error is
  /// thrown.
  Future<void> deleteNote(String id) => _notesApi.deleteNote(id);

  /// Deletes all completed Notes.
  /// Returns the number of deleted Notes.
  Future<int> clearArchived() => _notesApi.clearArchived();

  /// Sets the `isCompleted` state of all Notes to the given value.
  /// Returns the number of updated Notes.
  Future<int> archiveAll({required bool isArchived}) =>
      _notesApi.archiveAll(isArchived: isArchived);
}
