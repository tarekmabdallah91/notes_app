import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/note_model.dart';


class NoteDetailsPage extends StatelessWidget {
  static const route = '/NoteDetailsPage';
  NoteModel? note;

  NoteDetailsPage({super.key});

  static void openNoteDetailsPage(
    BuildContext context,
    String noteId,
  ) {
    Navigator.of(context).pushNamed(NoteDetailsPage.route, arguments: noteId);
  }

  void getNoteById(BuildContext context) {
    final noteId = ModalRoute.of(context)!.settings.arguments as String;
    // NoteCubit noteCubit = BlocProvider.of<NoteCubit>(context);
    // note = noteCubit.getNoteById(noteId);
  }

  @override
  Widget build(BuildContext context) {
    getNoteById(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(note!.title),
      ),
      body: Column(children: [
        Text(note!.body),
        const SizedBox(
          height: 10,
        ),
        Text(
          note!.noteTime,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          note!.noteCategory.name,
        ),
        const SizedBox(
          height: 10,
        ),
        note!.imageUrl.isEmpty
            ? const Spacer()
            : SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.file(
                  io.File(note!.imageUrl),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
      ]),
    );
  }
}
