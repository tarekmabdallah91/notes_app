import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/edit_note/cubit/edit_note_cubit.dart';
import 'package:notes_app/edit_note/edit_note.dart';
import 'package:notes_app/home/home.dart';
import 'package:notes_app/login/cubit/login_cubit.dart';
import 'package:notes_app/login/view/login_page.dart';
import 'package:notes_app/utils/text_utils.dart';
import 'package:notes_repository/note_repository.dart';
import 'package:go_router/go_router.dart';
import '../l10n/l10n.dart';
import '../theme/theme.dart';

class NotesApp extends StatelessWidget {
  const NotesApp({
    super.key,
    required this.notesRepository,
    required this.sessionRepository,
    required this.remoteRespository,
  });

  final NotesRepository notesRepository;
  final SessionRepository sessionRepository;
  final RemoteRepository remoteRespository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NotesRepository>(
            create: (context) => notesRepository),
        RepositoryProvider<SessionRepository>(
            create: (context) => sessionRepository),
        RepositoryProvider<RemoteRepository>(
            create: (context) => remoteRespository),
      ],
      child: AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(sessionRespository: context.read<SessionRepository>()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: FlutterNotesTheme.light,
        darkTheme: FlutterNotesTheme.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
      ),
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: LoginPage.route,
        name: LoginPage.route,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: HomePage.route,
        name: HomePage.route,
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: EditNotePage.route,
        name: EditNotePage.route,
        builder: (context, state) => BlocProvider(
          create: (context) => EditNoteCubit(
            context.read<NotesRepository>(),
            state.extra == null ? Note.initialNote() : state.extra as Note,
          ),
          child: const EditNotePage(),
        ),
      )
    ],
    redirect: (context, state) async {
      final stateCubit = BlocProvider.of<LoginCubit>(context).state;
      TextUtils.printLog("status", stateCubit);
      TextUtils.printLog("state", state.location);
      if (state.subloc != LoginPage.route &&
          stateCubit.status != LoginStatus.loggedin) {
        return LoginPage.route;
      }
      return null;
    },
    errorBuilder: (context, state) => ErrorScreen(state.error),
  );
}

class ErrorScreen extends StatelessWidget {
  ErrorScreen(this.error, {super.key});
  Exception? error;

  @override
  Widget build(BuildContext context) {
    TextUtils.printLog('ErrorScreen', error.toString());
    return Scaffold(
      body: Center(
        child: Text("Error occured! $error"),
      ),
    );
  }
}
