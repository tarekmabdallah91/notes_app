import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../pages/note_details_page.dart';

class NoteListItem extends StatelessWidget {
  final NoteModel note;
  const NoteListItem({required this.note});

  void openNoteDetailsPage(BuildContext context) {
    Navigator.of(context).pushNamed(NoteDetailsPage.route, arguments: note);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openNoteDetailsPage(context),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                note.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                note.body,
              ),
            ),
            Divider(),
          ]),
    );
  }
}
