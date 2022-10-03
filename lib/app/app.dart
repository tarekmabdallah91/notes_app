import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/home/home.dart';
import 'package:notes_repository/note_repository.dart';
import '../l10n/l10n.dart';
import '../theme/theme.dart';

class NotesApp extends StatelessWidget {
  const NotesApp({super.key, required this.notesRepository});

  final NotesRepository notesRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: notesRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlutterNotesTheme.light,
      darkTheme: FlutterNotesTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
