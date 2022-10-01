import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:notes_api/models/note.dart';
import 'package:notes_api/notes_api.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_storage_Notes_api}
/// A Flutter implementation of the [NotesApi] that uses local storage.
/// {@endtemplate}
class LocalStorageNotesApi extends NotesApi {
  /// {@macro local_storage_Notes_api}
  LocalStorageNotesApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _NoteStreamController = BehaviorSubject<List<Note>>.seeded(const []);

  /// The key used for storing the Notes locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kNotesCollectionKey = '__Notes_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final NotesJson = _getValue(kNotesCollectionKey);
    if (NotesJson != null) {
      final Notes = List<Map<dynamic, dynamic>>.from(
        json.decode(NotesJson) as List,
      )
          .map((jsonMap) => Note.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _NoteStreamController.add(Notes);
    } else {
      _NoteStreamController.add(const []);
    }
  }

  @override
  Stream<List<Note>> getNotes() => _NoteStreamController.asBroadcastStream();

  @override
  Future<void> saveNote(Note Note) {
    final Notes = [..._NoteStreamController.value];
    final NoteIndex = Notes.indexWhere((t) => t.id == Note.id);
    if (NoteIndex >= 0) {
      Notes[NoteIndex] = Note;
    } else {
      Notes.add(Note);
    }

    _NoteStreamController.add(Notes);
    return _setValue(kNotesCollectionKey, json.encode(Notes));
  }

  @override
  Future<void> deleteNote(String id) async {
    final Notes = [..._NoteStreamController.value];
    final NoteIndex = Notes.indexWhere((t) => t.id == id);
    if (NoteIndex == -1) {
      throw NoteNotFoundException();
    } else {
      Notes.removeAt(NoteIndex);
      _NoteStreamController.add(Notes);
      return _setValue(kNotesCollectionKey, json.encode(Notes));
    }
  }

  // @override
  // Future<int> clearCompleted() async {
  //   final Notes = [..._NoteStreamController.value];
  //   final completedNotesAmount = Notes.where((t) => t.isCompleted).length;
  //   Notes.removeWhere((t) => t.isCompleted);
  //   _NoteStreamController.add(Notes);
  //   await _setValue(kNotesCollectionKey, json.encode(Notes));
  //   return completedNotesAmount;
  // }

  // @override
  // Future<int> completeAll({required bool isCompleted}) async {
  //   final Notes = [..._NoteStreamController.value];
  //   final changedNotesAmount =
  //       Notes.where((t) => t.isCompleted != isCompleted).length;
  //   final newNotes = [
  //     for (final Note in Notes) Note.copyWith(isCompleted: isCompleted)
  //   ];
  //   _NoteStreamController.add(newNotes);
  //   await _setValue(kNotesCollectionKey, json.encode(newNotes));
  //   return changedNotesAmount;
  // }

}
