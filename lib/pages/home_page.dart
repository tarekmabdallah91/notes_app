import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/NoteProvider.dart';
import '../widgets/notes_list_item.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NoteProvider>(context).getNotes();
    print("build home page");
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
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
