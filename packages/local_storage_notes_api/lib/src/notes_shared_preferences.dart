part of 'local_storage_notes_api.dart';

class NotesSharedPreferences {
  final SharedPreferences _sharedPreferences;

  NotesSharedPreferences(this._sharedPreferences);

    /// The key used for storing the Notes locally.
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kNotesCollectionKey = '__Notes_collection_key__';

  String? getValue(String key) => _sharedPreferences.getString(key);
  Future<void> setValue(String key, String value) =>
      _sharedPreferences.setString(key, value);


  void init(BehaviorSubject<List<Note>> _noteStreamController){
    final notesJson = getValue(kNotesCollectionKey);
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

  Future<void> saveNote(BehaviorSubject<List<Note>> _noteStreamController, Note note) {
    final notes = [..._noteStreamController.value];
    final noteIndex = notes.indexWhere((element) => element.id == note.id);
    if (noteIndex >= 0) {
      notes[noteIndex] = note;
    } else {
      notes.add(note);
    }
    _noteStreamController.add(notes);
    return setValue(kNotesCollectionKey, json.encode(notes));
  }

  Future<void> deleteNote(BehaviorSubject<List<Note>> _noteStreamController, String id) async {
    final notes = [..._noteStreamController.value];
    final noteIndex = notes.indexWhere((element) => element.id == id);
    if (noteIndex == -1) {
      throw NoteNotFoundException();
    } else {
      notes.removeAt(noteIndex);
      _noteStreamController.add(notes);
      return setValue(kNotesCollectionKey, json.encode(notes));
    }
  }

  Future<int> clearArchived(BehaviorSubject<List<Note>> _noteStreamController) async {
    final notes = [..._noteStreamController.value];
    final archivedNotesAmount =
        notes.where((element) => element.isArchived).length;
    notes.removeWhere((element) => element.isArchived);
    _noteStreamController.add(notes);
    await setValue(kNotesCollectionKey, json.encode(notes));
    return archivedNotesAmount;
  }

  Future<int> archiveAll(BehaviorSubject<List<Note>> _noteStreamController, { required bool isArchived}) async {
    final notes = [..._noteStreamController.value];
    final changedNotesAmount =
        notes.where((element) => element.isArchived != isArchived).length;
    final newNotes = [
      for (final note in notes) note.copyWith(isArchived: isArchived)
    ];
    _noteStreamController.add(newNotes);
    await setValue(kNotesCollectionKey, json.encode(newNotes));
    return changedNotesAmount;
  }
}
