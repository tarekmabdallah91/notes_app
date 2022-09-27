import 'package:flutter/material.dart';
import 'package:notes_app/pages/add_note_page.dart';
import 'package:provider/provider.dart';

import '../provider/NoteProvider.dart';
import '../widgets/notes_list_item.dart';

class HomePage extends StatelessWidget {
  void openAddNotePage(BuildContext context) {
    Navigator.of(context).pushNamed(AddNotePage.route);
  }

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NoteProvider>(context).getNotes();
    print("build home page");
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            onPressed: () => openAddNotePage(context),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Center(
        child: ListView.builder(
            itemBuilder: (context, index) => NoteListItem(
                  note: notes[index],
                ),
            itemCount: notes.length),
      ),
    );
  }
}
