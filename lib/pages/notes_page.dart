import 'package:flutter/material.dart';
import 'package:notes_app/pages/add_note_page.dart';
import 'package:provider/provider.dart';

import '../provider/note_provider.dart';
import '../widgets/notes_list_item.dart';

class NotesPage extends StatelessWidget {
  void openAddNotePage(BuildContext context) {
    Navigator.of(context).pushNamed(AddNotePage.route);
  }

  @override
  Widget build(BuildContext context) {
    // final notes = Provider.of<NoteProvider>(context).getNotes();
    print("build notes page");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: () => openAddNotePage(context),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Consumer<NoteProvider>(
        child: const Center(
          child: Text('No Notes Added!, You can add now'),
        ),
        builder: (context, notes, consumerChild) => notes.notes.isEmpty
            ? consumerChild!
            : ListView.builder(
                itemBuilder: (context, index) => NoteListItem(
                      note: notes.notes[index],
                    ),
                itemCount: notes.notes.length),
      ),
    );
  }
}
