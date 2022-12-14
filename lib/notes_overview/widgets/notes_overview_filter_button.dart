import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/l10n/l10n.dart';

import '../cubit/notes_overview_cubit.dart';
import '../models/notes_view_filter.dart';

class NotesOverviewFilterButton extends StatelessWidget {
  const NotesOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final activeFilter =
        context.select((NotesOverviewCubit cubit) => cubit.state.filter);

    return PopupMenuButton<NotesViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip: l10n.notesOverviewFilterTooltip,
      onSelected: (filter) {
        context
            .read<NotesOverviewCubit>().onFilterChanged(filter);
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: NotesViewFilter.all,
            child: Text(l10n.notesOverviewFilterAll),
          ),
          PopupMenuItem(
            value: NotesViewFilter.activeOnly,
            child: Text(l10n.notesOverviewFilterActiveOnly),
          ),
          PopupMenuItem(
            value: NotesViewFilter.archiveddOnly,
            child: Text(l10n.notesOverviewFilterArchivedOnly),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
