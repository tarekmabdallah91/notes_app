import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_api/notes_api.dart';
import 'package:notes_app/l10n/l10n.dart';
import 'package:notes_repository/note_repository.dart';

import '../bloc/edit_note_bloc.dart';


class EditNotePage extends StatelessWidget {
  const EditNotePage({super.key});

  static Route<void> route({Note? initialNote}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditNoteBloc(
          notesRepository: context.read<NotesRepository>(),
          initialNote: initialNote,
        ),
        child: const EditNotePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditNoteBloc, EditNoteState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditNoteStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditNoteView(),
    );
  }
}

class EditNoteView extends StatelessWidget {
  const EditNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((EditNoteBloc bloc) => bloc.state.status);
    final isNewNote = context.select(
      (EditNoteBloc bloc) => bloc.state.isNewNote,
    );
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewNote
              ? l10n.editNoteAddAppBarTitle
              : l10n.editNoteEditAppBarTitle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.editNoteSaveButtonTooltip,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context.read<EditNoteBloc>().add(const EditNoteSubmitted()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [_TitleField(), _DescriptionField()],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditNoteBloc>().state;
    final hintText = state.initialNote?.title ?? '';

    return TextFormField(
      key: const Key('editNoteView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editNoteTitleLabel,
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context.read<EditNoteBloc>().add(EditNoteTitleChanged(value));
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final state = context.watch<EditNoteBloc>().state;
    final hintText = state.initialNote?.body ?? '';

    return TextFormField(
      key: const Key('editNoteView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editNoteDescriptionLabel,
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context.read<EditNoteBloc>().add(EditNoteDescriptionChanged(value));
      },
    );
  }
}
