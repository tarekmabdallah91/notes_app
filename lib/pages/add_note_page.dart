import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/provider/note_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/btn_add_note_page.dart';
import '../widgets/image_input.dart';
import '../widgets/note_text_field.dart';

class AddNotePage extends StatefulWidget {
  static const route = '/AddNotePage';

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
  late TextEditingController _titleController, _bodyController;
  late NoteTextField titleTextField, bodyTextField;
  File? _pickedImage;
  NoteModel? editableNote;
  late bool isNewNote;

  @override
  void didChangeDependencies() {
    try {
      editableNote = ModalRoute.of(context)!.settings.arguments as NoteModel;
    } catch (error) {
      print(error);
    }
    isNewNote = editableNote == null;
    if (null != editableNote) print('${editableNote!.id}');
    titleTextField = NoteTextField(
        label: 'Title', text: isNewNote ? '' : editableNote!.title);
    _titleController = titleTextField.getTextEditingController();
    bodyTextField =
        NoteTextField(label: 'Body', text: isNewNote ? '' : editableNote!.body);
    _bodyController = bodyTextField.getTextEditingController();
    super.didChangeDependencies();
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void saveNote() {
    print('saveNote');
    if (_titleController.text.isEmpty ||
        _bodyController.text.isEmpty ||
        _pickedImage == null) return;

    NoteModel noteModel = NoteModel(
      id: DateTime.now().toString(),
      title: _titleController.text,
      body: _bodyController.text,
      noteTime: DateFormat('yyyy-MM-dd – HH:mm:ss').format(DateTime.now()),
      imageUrl: _pickedImage!.path,
    );
    print('${noteModel.id}');
    Provider.of<NoteProvider>(context, listen: false).addNote(noteModel);
    Navigator.of(context).pop();
  }

  void updateNote() {
    print('updateNote');
    if (_titleController.text.isEmpty ||
        _bodyController.text.isEmpty ||
        _pickedImage == null) return;

    editableNote = NoteModel(
      id: editableNote!.id,
      title: _titleController.text,
      body: _bodyController.text,
      noteTime: DateFormat('yyyy-MM-dd – HH:mm:ss').format(DateTime.now()),
      imageUrl: _pickedImage!.path,
    );
    Provider.of<NoteProvider>(context, listen: false).updateNote(editableNote!);
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
                    ImageInput(_selectImage),
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
