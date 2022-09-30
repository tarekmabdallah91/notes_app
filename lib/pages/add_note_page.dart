import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/cubit/note_cubit.dart';
import 'package:notes_app/models/note_category.dart';
import 'package:notes_app/models/note_model.dart';
import '../utils/text_utils.dart';
import '../widgets/btn_add_note_page.dart';
import '../widgets/image_input.dart';
import '../widgets/note_text_field.dart';

class AddNotePage extends StatefulWidget {
  static const route = '/AddNotePage';
  final tag = 'AddNotePage';

  const AddNotePage({super.key});

  static void openAddNotePage(
    BuildContext context, {
    Object? arguments,
  }) {
    Navigator.of(context).pushNamed(AddNotePage.route, arguments: arguments);
  }

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late TextEditingController _titleController,
      _bodyController,
      _categoryController;
  late NoteTextField titleTextField, bodyTextField, categoryTextField;
  File? _pickedImage;
  NoteModel? editableNote;
  late bool isNewNote;

  @override
  void didChangeDependencies() {
    try {
      final noteId = ModalRoute.of(context)!.settings.arguments as String;
      NoteCubit noteCubit = BlocProvider.of<NoteCubit>(context);
      noteCubit.getNoteById(noteId); // TODO to fix noteCubit.noteModel as it's null now 
      editableNote = noteCubit.noteModel;
    } catch (error) {
      TextUtils.printLog(widget.tag, error);
    }
    isNewNote = editableNote == null;
    if (null != editableNote) {
      TextUtils.printLog(widget.tag, 'editable note id = ${editableNote!.id}');
      _pickedImage = File(editableNote!.imageUrl);
    }

    titleTextField = NoteTextField(
        label: 'Title', text: isNewNote ? '' : editableNote!.title);
    _titleController = titleTextField.getTextEditingController();
    bodyTextField =
        NoteTextField(label: 'Body', text: isNewNote ? '' : editableNote!.body);
    _bodyController = bodyTextField.getTextEditingController();
    categoryTextField = NoteTextField(
        label: 'Category',
        text: isNewNote ? '' : editableNote!.noteCategory.name);
    _categoryController = categoryTextField.getTextEditingController();
    super.didChangeDependencies();
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void saveNote() {
    TextUtils.printLog(widget.tag, 'saveNote');
    if (_titleController.text.isEmpty ||
        _bodyController.text.isEmpty ||
        _pickedImage == null) return;

    NoteModel noteModel = NoteModel(
      id: DateTime.now().toString(),
      title: _titleController.text,
      body: _bodyController.text,
      noteTime: DateFormat('yyyy-MM-dd – HH:mm:ss').format(DateTime.now()),
      imageUrl: _pickedImage!.path,
      noteCategory: NoteCategory(
        id: DateTime.now().toString(),
        name: _categoryController.text,
      ),
    );
    BlocProvider.of<NoteCubit>(context).addNote(noteModel);
    Navigator.of(context).pop();
  }

  void updateNote() {
    TextUtils.printLog(widget.tag, 'updateNote');
    if (_titleController.text.isEmpty ||
        _bodyController.text.isEmpty ||
        _pickedImage == null) return;

    editableNote = NoteModel(
      id: editableNote!.id,
      title: _titleController.text,
      body: _bodyController.text,
      noteTime: DateFormat('yyyy-MM-dd – HH:mm:ss').format(DateTime.now()),
      imageUrl: _pickedImage!.path,
      noteCategory: NoteCategory(
          id: DateTime.now().toString(), name: _categoryController.text),
    );
    BlocProvider.of<NoteCubit>(context).addNote(editableNote!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Note'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    titleTextField,
                    const SizedBox(
                      height: 10,
                    ),
                    bodyTextField,
                    const SizedBox(
                      height: 10,
                    ),
                    categoryTextField,
                    const SizedBox(
                      height: 10,
                    ),
                    ImageInput(
                        onSelectImage: _selectImage,
                        savedImagePath:
                            isNewNote ? '' : editableNote!.imageUrl),
                  ],
                ),
              ),
            ),
          ),
          AddNoteBtn(
              label: isNewNote ? 'Add Note' : 'Update Note',
              iconDate: isNewNote ? Icons.add : Icons.save,
              onTapBtn: isNewNote ? saveNote : updateNote)
        ],
      ),
    );
  }
}
