import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/home/view/notes_page.dart';
import 'package:notes_repository/note_repository.dart';
import '../theme/theme.dart';

class NotesApp extends StatelessWidget {
  const NotesApp({super.key, required this.notesRepository});

  final NotesRepository notesRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: NotesRepository,
      child: AppView(notesRepository: notesRepository),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key, required this.notesRepository});
  final NotesRepository notesRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterNotesTheme.light,
      darkTheme: FlutterNotesTheme.dark,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      home: NotesPage(notesRepository: notesRepository),
    );
  }
}
