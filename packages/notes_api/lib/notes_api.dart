import 'package:notes_api/models/note.dart';

abstract class NotesApi {
  /// {@macro Notes_api}
  const NotesApi();

  /// Provides a [Stream] of all Notes.
  Stream<List<Note>> getNotes();

// https://bloclibrary.dev/#/fluttertodostutorial?id=streams-vs-futures
// A Future-based implementation could consist of two methods: loadTodos and saveTodos (note the plural). This means, a full list of todos must be provided to the method each time.

//     One limitation of this approach is that the standard CRUD (Create, Read, Update, and Delete) operation requires sending the full list of todos with each call. For example, on an Add Todo screen, one cannot just send the added todo item. Instead, we must keep track of the entire list and provide the entire new list of todos when persisting the updated list.
//     A second limitation is that loadTodos is a one-time delivery of data. The app must contain logic to ask for updates periodically.

// In the current implementation, the TodosApi exposes a Stream<List<Todo>> via getTodos() which will report real-time updates to all subscribers when the list of todos has changed.

// In addition, todos can be created, deleted, or updated individually. For example, both deleting and saving a todo are done with only the todo as the argument. It's not necessary to provide the newly updated list of todos each time.

  /// Saves a [Note].
  ///
  /// If a [Note] with the same id already exists, it will be replaced.
  Future<void> saveNote(Note noteModel);

  /// Deletes the NoteModel with the given id.
  ///
  /// If no NoteModel with the given id exists, a [NoteModelNotFoundException] error is
  /// thrown.
  Future<void> deleteNote(String id);

  /// Deletes all completed Notes.
  ///
  /// Returns the number of deleted Notes.
  // Future<int> clearCompleted();

  /// Sets the `isCompleted` state of all Notes to the given value.
  ///
  /// Returns the number of updated Notes.
  // Future<int> completeAll({required bool isCompleted});
}

/// Error thrown when a [Note] with a given id is not found.
class NoteNotFoundException implements Exception {}
