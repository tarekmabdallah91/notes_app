import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
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

  final _noteStreamController = BehaviorSubject<List<Note>>.seeded(const []);

  /// The key used for storing the Notes locally.
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kNotesCollectionKey = '__Notes_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final notesJson = _getValue(kNotesCollectionKey);
    if (notesJson != null) {
      final notes = List<Map<dynamic, dynamic>>.from(
        json.decode(notesJson) as List,
      )
          .map((jsonMap) => Note.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _noteStreamController.add(notes);
    } else {
      _noteStreamController.add(const []);
    }
  }

  @override
  Stream<List<Note>> getNotes() => _noteStreamController.asBroadcastStream();

  @override
  Future<void> saveNote(Note note) {
    final notes = [..._noteStreamController.value];
    final noteIndex = notes.indexWhere((element) => element.id == note.id);
    if (noteIndex >= 0) {
      notes[noteIndex] = note;
    } else {
      notes.add(note);
    }
    _noteStreamController.add(notes);
    return _setValue(kNotesCollectionKey, json.encode(notes));
  }

  @override
  Future<void> deleteNote(String id) async {
    final notes = [..._noteStreamController.value];
    final noteIndex = notes.indexWhere((element) => element.id == id);
    if (noteIndex == -1) {
      throw NoteNotFoundException();
    } else {
      notes.removeAt(noteIndex);
      _noteStreamController.add(notes);
      return _setValue(kNotesCollectionKey, json.encode(notes));
    }
  }

  @override
  Future<int> clearArchived() async {
    final notes = [..._noteStreamController.value];
    final completedNotesAmount = notes.where((element) => element.isArchived).length;
    notes.removeWhere((element) => element.isArchived);
    _noteStreamController.add(notes);
    await _setValue(kNotesCollectionKey, json.encode(notes));
    return completedNotesAmount;
  }

  @override
  Future<int> archiveAll({required bool isArchived}) async {
    final notes = [..._noteStreamController.value];
    final changedNotesAmount =
        notes.where((element) => element.isArchived != isArchived).length;
    final newNotes = [
      for (final note in notes) note.copyWith(isArchived: isArchived)
    ];
    _noteStreamController.add(newNotes);
    await _setValue(kNotesCollectionKey, json.encode(newNotes));
    return changedNotesAmount;
  }
}
