import 'package:flutter/material.dart';

import '../models/note_model.dart';

class NoteListItem extends StatelessWidget {
  final NoteModel note;
  const NoteListItem({required this.note});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(note.title);
      },
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
