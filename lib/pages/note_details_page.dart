import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';

class NoteDetailsPage extends StatelessWidget {
  static const route = '/NoteDetailsPage';
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
        Text(
          note.noteTime,
        ),
        //  note.imageUrl.isEmpty ? Spacer() : Image.network(note.imageUrl),
      ]),
    );
  }
}
