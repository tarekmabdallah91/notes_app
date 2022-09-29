import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/note_cubit.dart';
import 'package:notes_app/cubit/note_states.dart';
import 'package:notes_app/pages/add_note_page.dart';
import '../utils/text_utils.dart';
import '../widgets/notes_list_item.dart';

class NotesPage extends StatelessWidget {
  static const route = '/NotesPage';

  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextUtils.printLog(route, "build notes page ${DateTime.now()}");
    NoteCubit noteCubit = BlocProvider.of<NoteCubit>(context);
    noteCubit.getAllNotes();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: () => AddNotePage.openAddNotePage(context),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: BlocBuilder<NoteCubit, NoteState>(builder: (context, state) {
        if (state is InitNoteState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetAllNotesState) {
          return noteCubit.notes.isEmpty
              ? const Center(child: Text('please add notes !'))
              : ListView.builder(
                  itemBuilder: (context, index) => NoteListItem(
                        note: noteCubit.notes[index],
                      ),
                  itemCount: noteCubit.notes.length);
        } else {
          return const Center(
            child: Text('Error no data available !'),
          );
        }
      }),
    );
  }
}
