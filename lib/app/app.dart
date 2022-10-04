import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/home/home.dart';
import 'package:notes_app/login/view/login_page.dart';
import 'package:notes_repository/note_repository.dart';
import '../l10n/l10n.dart';
import '../theme/theme.dart';

class NotesApp extends StatelessWidget {
  const NotesApp({
    super.key,
    required this.notesRepository,
    required this.sessionRepository,
  });

  final NotesRepository notesRepository;
  final SessionRepository sessionRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NotesRepository>(
            create: (context) => notesRepository),
        RepositoryProvider<SessionRepository>(
            create: (context) => sessionRepository),
      ],
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
      home: const LoginPage(),
    );
  }
}
