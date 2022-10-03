import 'package:notes_api/notes_api.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class NotesDb {
  final dbName = 'notes_database.db', tableName = 'notes';
  Future<Database> database() async {
    // Open the database and store the reference.
    final dbPath = await sql.getDatabasesPath();
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    return sql.openDatabase(path.join(dbPath, dbName), onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $tableName (`id` TEXT PRIMARY KEY NOT NULL, `title` TEXT NOT NULL, `body` TEXT NOT NULL, `noteTime` TEXT NOT NULL, `imageUrl` TEXT NOT NULL, `isArchived` BIT NOT NULL)');
    }, version: 1);
  }

  Future<void> addNote(Note noteModel) async {
    final db = await database();
    db.transaction(
      (txn) => txn.insert(
        tableName,
        noteModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    );
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database();
    final List<Map<String, dynamic>> maps =
        await db.transaction((txn) => txn.query(tableName));
    // Convert the List<Map<String, dynamic> into a List<NoteModel>.
    return List.generate(maps.length, (index) {
      return Note.fromJson(maps[index]);
    });
  }

  Future<Note> getNoteById(String id) async {
    final db = await database();
    var map = await db.transaction((txn) => txn.query(
          tableName,
          where: 'id = ?',
          whereArgs: [id],
        ));
    return Note.fromJson(map.first);
  }

  Future<void> deleteNote(String id) async {
    final db = await database();
    await db.transaction((txn) => txn.delete(
          tableName,
          // Use a `where` clause to delete a specific NoteModel.
          where: 'id = ?',
          // Pass the NoteModel's id as a whereArg to prevent SQL injection.
          whereArgs: [id],
        ));
  }

  Future<int> clearArchived() async {
    final notes = await getAllNotes();
    final archivedNotesAmount =
        notes.where((element) => element.isArchived).length;
    notes.removeWhere((element) => element.isArchived);
    return archivedNotesAmount;
  }

  Future<int> archiveAll({required bool isArchived}) async {
    final notes = await getAllNotes();
    final changedNotesAmount =
        notes.where((element) => element.isArchived != isArchived).length;
    final newNotes = [
      for (final note in notes) note.copyWith(isArchived: isArchived)
    ];
    return changedNotesAmount;
  }
}
