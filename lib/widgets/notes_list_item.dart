import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_api/notes_api.dart';
import 'package:notes_app/cubit/note_cubit.dart';

import '../models/note_model.dart';
import '../pages/add_note_page.dart';
import '../pages/note_details_page.dart';

class NoteListItem extends StatelessWidget {
  final Note note;

  const NoteListItem({
    super.key,
    required this.note,
  });

  void editNote(BuildContext context) {
    AddNotePage.openAddNotePage(
      context,
      arguments: note.id,
    );
  }

  void deleteNote(BuildContext context) {
    // BlocProvider.of<NoteCubit>(context).deleteNote(note.id);
  }

  void openNoteDetailsPage(BuildContext context) {
    NoteDetailsPage.openNoteDetailsPage(
      context,
      note.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => openNoteDetailsPage(context),
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
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => deleteNote(context),
                        icon: const Icon(Icons.delete),
                      ),
                    ]),
              ]),
        ),
      ),
    );
  }
}
