import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';

class NoteDetailsPage extends StatelessWidget {
  static const route = '/NoteDetailsPage';

  @override
  Widget build(BuildContext context) {
    final note = ModalRoute.of(context)!.settings.arguments as NoteModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: Text(note.body),
    );
  }
}
