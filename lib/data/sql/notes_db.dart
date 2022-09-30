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
    db.insert(
      tableName,
      noteModel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NoteModel>> getAllNotes() async {
    final db = await database();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    // Convert the List<Map<String, dynamic> into a List<NoteModel>.
    TextUtils.printLog('getAllNotes ', maps);
    return List.generate(maps.length, (index) {
      return NoteModel.fromJson(maps[index]);
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
      noteCategory: map['noteCategory'],
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

  // {
  //   id: 2022-09-29 21:24:54.953626,
  //   title: note 1,
  //   body: body,
  //   noteTime: 2022-09-29 – 21:24:54,
  //   imageUrl: /data/user/0/com.example.notes_app/app_flutter/scaled_dd6d1aa1-1b48-4eea-98f6-50bdc8816d608722402423271091310.jpg, 
  //   noteCategory: {name=sjadlf;, id=2022-09-29 21:24:54.986942}
  //   }, 
  //   {
  //     id: 2022-09-29 21:27:33.947814, 
  //     title: ASAS, 
  //     body: SAs, 
  //     noteTime: 2022-09-29 – 21:27:33, 
  //     imageUrl: /data/user/0/com.example.notes_app/app_flutter/scaled_46095286-85a1-4ab9-8040-8c663e9e56ff4444298962513195102.jpg, 
  //     noteCategory: {name=SAas, id=2022-09-29 21:27:33.993644}}, 
      
  //   {
  //     id: 2022-09-29 21:39:33.782336, 
  //     title: note 1, 
  //     body: body 1, 
  //     noteTime: 2022-09-29 – 21:39:33, 
  //     imageUrl: /data/user/0/com.example.notes_app/app_flutter/scaled_21b2022f-4236-4209-913e-450251b107123572555048356674746.jpg, 
  //     noteCategory: {"id":"2022-09-29 21:39:33.814677","name":"cate 1"}
  //   }


      // [{id: 2022-09-29 21:57:30.501362,
      //  title: sadszd, 
      //  body: sdasdas, 
      //  noteTime: 2022-09-29 – 21:57:30, 
      //  imageUrl: /data/user/0/com.example.notes_app/app_flutter/scaled_f3d2e858-fe1c-4fc0-8a32-612cd5082bc9692417294331547903.jpg, 
      //  noteCategory: {name=sdasdasd, id=2022-09-29 21:57:30.507994}
      // }]