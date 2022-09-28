import 'package:flutter/material.dart';
import 'package:notes_app/provider/note_provider.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../pages/add_note_page.dart';
import '../pages/note_details_page.dart';

class NoteListItem extends StatelessWidget {
  final NoteModel note;
  const NoteListItem({super.key, required this.note});

  void editNote(BuildContext context) {
    // open edit page
    AddNotePage.openAddNotePage(
      context,
      arguments: note,
    );
  }

  void deleteNote(BuildContext context) {
    Provider.of<NoteProvider>(context, listen: false).deleteNote(note.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          NoteDetailsPage.openNoteDetailsPage(context, note);
        },
        child: Card(
          elevation: 5,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(note.title),
                Text(note.body),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => editNote(context),
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => deleteNote(context),
                        icon: Icon(Icons.delete),
                      ),
                    ]),
              ]),
        ),
      ),
    );
  }
}
