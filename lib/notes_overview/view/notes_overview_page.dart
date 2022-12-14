import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/l10n/l10n.dart';
import 'package:notes_app/login/cubit/login_cubit.dart';
import 'package:notes_app/notes_overview/cubit/notes_overview_cubit.dart';
import 'package:notes_repository/note_repository.dart';

import '../../edit_note/view/edit_note_page.dart';
import '../widgets/note_list_tile.dart';
import '../widgets/notes_overview_filter_button.dart';
import '../widgets/notes_overview_options_button.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => NotesOverviewCubit(
                notesRepository: context.read<NotesRepository>(),
                remoteRepository: context.read<RemoteRepository>())),
        BlocProvider(
          create: (context) =>
              LoginCubit(sessionRespository: context.read<SessionRepository>()),
        ),
      ],
      child: const NotesOverviewView(),
    );
  }
}

class NotesOverviewView extends StatelessWidget {
  const NotesOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notesOverviewAppBarTitle),
        actions: const [
          NotesOverviewFilterButton(),
          NotesOverviewOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<NotesOverviewCubit, NotesOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == NotesOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.notesOverviewErrorSnackbarText),
                    ),
                  );
              }
            },
          ),
          BlocListener<NotesOverviewCubit, NotesOverviewState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedNote != current.lastDeletedNote &&
                current.lastDeletedNote != null,
            listener: (context, state) {
              final deletedNote = state.lastDeletedNote!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.notesOverviewNoteDeletedSnackbarText(
                          deletedNote.title),
                    ),
                    action: SnackBarAction(
                      label: l10n.notesOverviewUndoDeletionButtonText,
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<NotesOverviewCubit>()
                            .onUndoDeletionRequested();
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<NotesOverviewCubit, NotesOverviewState>(
          builder: (context, state) {
            if (state.notes.isEmpty) {
              if (state.status == NotesOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != NotesOverviewStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    l10n.notesOverviewEmptyText,
                    style: Theme.of(context).textTheme.caption,
                  ),
                );
              }
            }

            return CupertinoScrollbar(
              child: ListView(
                children: [
                  for (final note in state.filteredNotes)
                    NoteListTile(
                      note: note,
                      onToggleArchived: (isArchived) {
                        context
                            .read<NotesOverviewCubit>()
                            .onNoteArchivedToggled(
                              note: note,
                              isArchived: isArchived,
                            );
                      },
                      onDismissed: (_) {
                        context.read<NotesOverviewCubit>().onNoteDeleted(note);
                      },
                      onTap: () {
                        GoRouter.of(context)
                            .pushNamed(EditNotePage.route, extra: note);
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
