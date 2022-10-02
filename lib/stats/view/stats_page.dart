import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/l10n/l10n.dart';
import 'package:notes_repository/note_repository.dart';

import '../bloc/stats_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsBloc(
        notesRepository: context.read<NotesRepository>(),
      )..add(const StatsSubscriptionRequested()),
      child: const StatsView(),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<StatsBloc>().state;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statsAppBarTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            key: const Key('statsView_completedNotes_listTile'),
            leading: const Icon(Icons.check_rounded),
            title: Text(l10n.statsActiveNoteCountLabel),
            trailing: Text(
              '${state.completedNotes}',
              style: textTheme.headline5,
            ),
          ),
          ListTile(
            key: const Key('statsView_activeNotes_listTile'),
            leading: const Icon(Icons.radio_button_unchecked_rounded),
            title: Text(l10n.statsActiveNoteCountLabel),
            trailing: Text(
              '${state.activeNotes}',
              style: textTheme.headline5,
            ),
          ),
        ],
      ),
    );
  }
}
