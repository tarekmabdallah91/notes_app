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
          'CREATE TABLE $tableName (`id` TEXT PRIMARY KEY NOT NULL, `title` TEXT NOT NULL, `body` TEXT NOT NULL, `noteTime` TEXT NOT NULL, `imageUrl` TEXT NOT NULL)');
    }, version: 1);
  }

  Future<void> insert(NoteModel noteModel) async {
    final db = await database();
    db.insert(
      tableName,
      noteModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NoteModel>> getAllNotes() async {
    final db = await database();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    // Convert the List<Map<String, dynamic> into a List<NoteModel>.
    return List.generate(maps.length, (index) {
      return NoteModel(
        id: maps[index]['id'],
        title: maps[index]['title'],
        body: maps[index]['body'],
        noteTime: maps[index]['noteTime'],
        imageUrl: maps[index]['imageUrl'],
      );
    });
  }

  Future<NoteModel> getNoteById(int id) async {
    final db = await database();
    final Map<String, dynamic> map = (await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    )) as Map<String, dynamic>;
    return NoteModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      noteTime: map['noteTime'],
      imageUrl: map['imageUrl'],
    );
  }

  ///  Warning: Always use whereArgs to pass arguments to a where statement. This helps safeguard against SQL injection attacks.
  ///  Do not use string interpolation, such as where: "id = ${noteModel.id}"!
  Future<void> updateNote(NoteModel noteModel) async {
    final db = await database();
    await db.update(
      tableName,
      noteModel.toMap(),
      // Ensure that the noteModel has a matching id.
      where: 'id = ?',
      // Pass the noteModel's id as a whereArg to prevent SQL injection.
      whereArgs: [noteModel.id],
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await database();
    await db.delete(
      tableName,
      // Use a `where` clause to delete a specific NoteModel.
      where: 'id = ?',
      // Pass the NoteModel's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
