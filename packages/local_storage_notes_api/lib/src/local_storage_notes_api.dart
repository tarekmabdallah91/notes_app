import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:notes_api/notes_api.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notes_db.dart';

part 'notes_shared_preferences.dart';

/// {@template local_storage_Notes_api}
/// A Flutter implementation of the [NotesApi] that uses local storage.
/// {@endtemplate}
class LocalStorageNotesApi extends NotesApi {
  /// {@macro local_storage_Notes_api}
  LocalStorageNotesApi({
    required SharedPreferences plugin,
  }) : _plugin = NotesSharedPreferences(plugin) {
    _init();
  }

  final NotesSharedPreferences _plugin;
  final NotesDb _notesDb = NotesDb();

  final _noteStreamController = BehaviorSubject<List<Note>>.seeded(const []);

  void _init() async {
    // _plugin._init(_noteStreamController);
    _noteStreamController.add(await _notesDb.getAllNotes());
  }

  @override
  Stream<List<Note>> getNotes() => _noteStreamController.asBroadcastStream();

  @override
  Future<void> saveNote(Note note) {
    _saveNoteStreamController(note);
    return _notesDb.addNote(note);
    // return _plugin.saveNote(_noteStreamController, note);
  }

  void _saveNoteStreamController(Note note) {
    _updateStreamController((notes) {
      final noteIndex = notes.indexWhere((element) => element.id == note.id);
      if (noteIndex >= 0) {
        notes[noteIndex] = note;
      } else {
        notes.add(note);
      }
    });
  }

  void _updateStreamController(
      Function(List<Note> notes) updateStramController) {
    final notes = [..._noteStreamController.value];
    updateStramController(notes);
    _noteStreamController.add(notes);
  }

  @override
  Future<void> deleteNote(String id) async {
    _deleteNoteStreamController(id);
    return _notesDb.deleteNote(id);
    // return _plugin.deleteNote(_noteStreamController, id);
  }

  void _deleteNoteStreamController(String id) {
    _updateStreamController((notes) {
      final noteIndex = notes.indexWhere((element) => element.id == id);
      if (noteIndex == -1) {
        throw NoteNotFoundException();
      } else {
        notes.removeAt(noteIndex);
      }
    });
  }

  @override
  Future<int> clearArchived() async {
    _clearArchivedStreamController();
    int count = await _notesDb.clearArchived();
    print('deleted count = $count');
    var items = await _notesDb.getAllNotes();
    print('current db count = $items');
    return count;
    // return await _plugin.clearArchived(_noteStreamController);
  }

  void _clearArchivedStreamController() {
    _updateStreamController((notes) {
      notes.removeWhere((element) => element.isArchived);
    });
  }

  @override
  Future<int> archiveAll({required bool isArchived}) async {
    archiveAllStreamController(isArchived: isArchived);
    return _notesDb.archiveAll(isArchived: isArchived);
    // return await _plugin.archiveAll(_noteStreamController,
    //     isArchived: isArchived);
  }

  void archiveAllStreamController({required bool isArchived}) {
    final notes = [..._noteStreamController.value];
    final changedNotesAmount =
        notes.where((element) => element.isArchived != isArchived).length;
    final newNotes = [
      for (final note in notes) note.copyWith(isArchived: isArchived)
    ];
    _noteStreamController.add(newNotes);
  }
}
