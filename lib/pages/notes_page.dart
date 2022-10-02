import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/note_cubit.dart';
import 'package:notes_app/cubit/note_states.dart';
import 'package:notes_app/pages/add_note_page.dart';
import 'package:notes_repository/note_repository.dart';
import '../utils/text_utils.dart';
import '../widgets/notes_list_item.dart';

class NotesPage extends StatelessWidget {
  static const route = '/NotesPage';
  final NotesRepository notesRepository;
  const NotesPage({super.key, required this.notesRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteCubit(notesRepository)..getAllNotes(),
      child: const NotesView(),
    );
  }
}

class NotesView extends StatelessWidget {
  const NotesView({super.key});
  final tag = 'NotesView';
  @override
  Widget build(BuildContext context) {
    TextUtils.printLog(tag, "build notes page ${DateTime.now()}");
    // NoteCubit noteCubit = BlocProvider.of<NoteCubit>(context);
    // noteCubit.getAllNotes();

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
      body: NotesListStatesWidget(tag: tag),
    );
  }
}

class NotesListStatesWidget extends StatelessWidget {
  const NotesListStatesWidget({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(builder: (context, state) {
      TextUtils.printLog(tag, state);
      if (state is InitNoteState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is GetAllNotesState
          // || state is AddNoteState ||
          //     state is UpdateNoteState ||
          //     state is DeleteNoteState
          ) {
        return state.notes.isEmpty
            ? const Center(child: Text('please add notes !'))
            : ListView.builder(
                itemBuilder: (context, index) => NoteListItem(
                      note: state.notes[index],
                    ),
                itemCount: state.notes.length);
      } else {
        return const Center(
          child: Text('Error no data available !'),
        );
      }
    });
  }
}
