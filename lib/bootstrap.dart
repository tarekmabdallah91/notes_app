import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_api/notes_api.dart';
import 'package:notes_repository/note_repository.dart';

import 'app/app.dart';
import 'app/app_bloc_observer.dart';

void bootstrap({
  required NotesApi notesApi,
  required SessionApi sessionApi,
  required RemoteApi remoteApi,
}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();

  final notesRepository = NotesRepository(notesApi: notesApi);
  final sessionRepository = SessionRepository(sessionApi);
  final remoteRespository = RemoteRepository(remoteApi);

  runZonedGuarded(
    () => runApp(NotesApp(
      notesRepository: notesRepository,
      sessionRepository: sessionRepository,
       remoteRespository: remoteRespository,
    )),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
