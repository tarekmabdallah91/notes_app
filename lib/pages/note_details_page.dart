import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:notes_app/models/converter/note_category_converter.dart';
import 'package:notes_app/models/note_model.dart';

class NoteDetailsPage extends StatelessWidget {
  static const route = '/NoteDetailsPage';

  const NoteDetailsPage({super.key});
  static void openNoteDetailsPage(BuildContext context, NoteModel note) {
    Navigator.of(context).pushNamed(NoteDetailsPage.route, arguments: note);
  }

  @override
  Widget build(BuildContext context) {
    final note = ModalRoute.of(context)!.settings.arguments as NoteModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: Column(children: [
        Text(note.body),
        SizedBox(
          height: 10,
        ),
        Text(
          note.noteTime,
        ),
        SizedBox(
          height: 10,
        ),
        // Text(
        //   const NoteCategoryConverter().fromJson(note.noteCategoryJson).name,
        // ),
        SizedBox(
          height: 10,
        ),
        note.imageUrl.isEmpty
            ? Spacer()
            : Container(
                height: 250,
                width: double.infinity,
                child: Image.file(
                  io.File(note.imageUrl),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
      ]),
    );
  }
}
