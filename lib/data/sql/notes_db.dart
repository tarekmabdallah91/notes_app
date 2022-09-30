import 'package:notes_app/models/converter/note_category_converter.dart';
import 'package:notes_app/models/note_category.dart';
import 'package:notes_app/utils/text_utils.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import '../../models/note_model.dart';

class NotesDb {
  final dbName = 'notes.db', tableName = 'notes';
  Future<Database> database() async {
    // Open the database and store the reference.
    final dbPath = await sql.getDatabasesPath();
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    return sql.openDatabase(path.join(dbPath, dbName), onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $tableName (`id` TEXT PRIMARY KEY NOT NULL, `title` TEXT NOT NULL, `body` TEXT NOT NULL, `noteTime` TEXT NOT NULL, `imageUrl` TEXT NOT NULL, `noteCategory` TEXT NOT NULL)');
    }, version: 2);
  }

  Future<void> addNote(NoteModel noteModel) async {
    final db = await database();
    db.transaction(
      (txn) => txn.insert(
        tableName,
        noteModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    );
  }

  Future<List<NoteModel>> getAllNotes() async {
    final db = await database();
    final List<Map<String, dynamic>> maps =
        await db.transaction((txn) => txn.query(tableName));
    // Convert the List<Map<String, dynamic> into a List<NoteModel>.
    TextUtils.printLog('getAllNotes ', maps);
    return List.generate(maps.length, (index) {
      return NoteModel.fromJson(maps[index]);
    });
  }

  Future<NoteModel> getNoteById(String id) async {
    final db = await database();
    var map = await db.transaction((txn) => txn.query(
          tableName,
          where: 'id = ?',
          whereArgs: [id],
        ));
    return NoteModel.fromJson(map.first);
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
}
