import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/l10n/l10n.dart';
import 'package:notes_app/login/login.dart';

import '../cubit/notes_overview_cubit.dart';


@visibleForTesting
enum NotesOverviewOption { toggleAll, clearCompleted, logout }

class NotesOverviewOptionsButton extends StatelessWidget {
  const NotesOverviewOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final notes = context.select((NotesOverviewCubit cubit) => cubit.state.notes);
    final hasNotes = notes.isNotEmpty;
    final archivedTodosAmount = notes.where((note) => note.isArchived).length;

    return PopupMenuButton<NotesOverviewOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      tooltip: l10n.notesOverviewOptionsTooltip,
      onSelected: (options) {
        switch (options) {
          case NotesOverviewOption.toggleAll:
            context
                .read<NotesOverviewCubit>().onToggleAllRequested();
            break;
          case NotesOverviewOption.clearCompleted:
            context
                .read<NotesOverviewCubit>().onClearArchivedRequested();
            break;
          case NotesOverviewOption.logout:
            context.read<LoginCubit>().loggout(
                  () => GoRouter.of(context).push(LoginPage.route),
                );
            break;
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: NotesOverviewOption.toggleAll,
            enabled: hasNotes,
            child: Text(
              archivedTodosAmount == notes.length
                  ? l10n.notesOverviewOptionsMarkAllInArchive
                  : l10n.notesOverviewOptionsMarkAllArchive,
            ),
          ),
          PopupMenuItem(
            value: NotesOverviewOption.clearCompleted,
            enabled: hasNotes && archivedTodosAmount > 0,
            child: Text(l10n.notesOverviewOptionsClearArchived),
          ),
          const PopupMenuItem(
            value: NotesOverviewOption.logout,
            child: Text('logout'),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}
