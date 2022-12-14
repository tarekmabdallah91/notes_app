import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/l10n/l10n.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import '../../utils/text_utils.dart';
import '../cubit/edit_note_cubit.dart';

class EditNotePage extends StatelessWidget {
  const EditNotePage({super.key});

  static const route = '/EditNotePage';

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditNoteCubit, EditNoteState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditNoteStatus.success,
      listener: (context, state) => GoRouter.of(context).pop(),
      child: const EditNoteView(),
    );
  }
}

class EditNoteView extends StatelessWidget {
  const EditNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((EditNoteCubit cubit) => cubit.state.status);
    final isNewNote = context.select(
      (EditNoteCubit cubit) => cubit.state.isNewNote,
    );
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    final _formKey = GlobalKey<FormState>();

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
            : () {
                if (_formKey.currentState!.validate()) {
                  context.read<EditNoteCubit>().onSaveNotePressed();
                }
              },
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: EditNoteForm(_formKey),
          ),
        ),
      ),
    );
  }
}

class EditNoteForm extends StatelessWidget {
  const EditNoteForm(
    this._formKey, {
    Key? key,
  }) : super(key: key);

  final _formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const _TitleField(),
          const _DescriptionField(),
          const SizedBox(height: 10),
          ImageInput(),
        ],
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = BlocProvider.of<EditNoteCubit>(context, listen: false).state;
    final hintText = state.initialNote?.title ?? '';

    return TextFormField(
      key: const Key('editNoteView_title_textFormField'),
      initialValue: state.initialNote!.title,
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
      onChanged: (value) => context.read<EditNoteCubit>().onTitleChanged(value),
      validator: (value) => context.read<EditNoteCubit>().validateTitle(value),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final state = context.watch<EditNoteCubit>().state;
    final hintText = state.initialNote?.body ?? '';

    return TextFormField(
        key: const Key('editNoteView_description_textFormField'),
        initialValue: state.initialNote!.body,
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
        onChanged: (value) =>
            context.read<EditNoteCubit>().onDescriptionChanged(value),
        validator: (value) =>
            context.read<EditNoteCubit>().validateDescription(value));
  }
}

class ImageInput extends StatelessWidget {
  final tag = 'ImageInput';
  String savedImagePath = '';

  ImageInput({super.key});

  void _saveImage(BuildContext context, String savedImagePath) {
    context.read<EditNoteCubit>().onImageChanged(savedImagePath);
  }

  Future<void> _takePicture(Function(String savedImagePath) saveImage) async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile!.path);
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');
    savedImagePath = savedImage.path;
    TextUtils.printLog(tag, savedImagePath);
    TextUtils.printLog(tag, '${appDir.path}/$fileName');

    saveImage(savedImagePath);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditNoteCubit>().state;
    savedImagePath = savedImagePath.isEmpty
        ? state.initialNote?.imageUrl ?? ''
        : savedImagePath;
    TextUtils.printLog(tag, savedImagePath);
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: savedImagePath.isEmpty
              ? const Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                )
              : Image.file(
                  File(savedImagePath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        // ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.camera),
            label: const Text('Take Picture'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              textStyle: const TextStyle(fontSize: 15),
              elevation: 0,
            ),
            onPressed: () {
              _takePicture(
                  (savedImagePath) => _saveImage(context, savedImagePath));
            },
          ),
        ),
      ],
    );
  }
}
