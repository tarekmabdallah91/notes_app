import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/l10n/l10n.dart';

import '../bloc/notes_overview_bloc.dart';


@visibleForTesting
enum NotesOverviewOption { toggleAll, clearCompleted }

class NotesOverviewOptionsButton extends StatelessWidget {
  const NotesOverviewOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final todos = context.select((NotesOverviewBloc bloc) => bloc.state.notes);
    final hasTodos = todos.isNotEmpty;
    final completedTodosAmount = todos.where((note) => note.isArchived).length;

    return PopupMenuButton<NotesOverviewOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      tooltip: l10n.notesOverviewOptionsTooltip,
      onSelected: (options) {
        switch (options) {
          case NotesOverviewOption.toggleAll:
            context
                .read<NotesOverviewBloc>()
                .add(const NotesOverviewToggleAllRequested());
            break;
          case NotesOverviewOption.clearCompleted:
            context
                .read<NotesOverviewBloc>()
                .add(const NotesOverviewClearCompletedRequested());
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: NotesOverviewOption.toggleAll,
            enabled: hasTodos,
            child: Text(
              completedTodosAmount == todos.length
                  ? l10n.notesOverviewOptionsMarkAllInArchive
                  : l10n.notesOverviewOptionsMarkAllArchive,
            ),
          ),
          PopupMenuItem(
            value: NotesOverviewOption.clearCompleted,
            enabled: hasTodos && completedTodosAmount > 0,
            child: Text(l10n.notesOverviewOptionsClearArchived),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}
