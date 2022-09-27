import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/provider/note_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/image_input.dart';

class AddNotePage extends StatefulWidget {
  static const route = '/AddNotePage';

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  File? _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void saveNote() {
    if (_titleController.text.isEmpty ||
        _bodyController.text.isEmpty ||
        _pickedImage == null) return;

    NoteModel noteModel = NoteModel(
      title: _titleController.text,
      body: _bodyController.text,
      imageUrl: _pickedImage!.path,
    );
    Provider.of<NoteProvider>(context, listen: false).addNote(noteModel);
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
                    TextField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'body'),
                      controller: _bodyController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ImageInput(_selectImage),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Note'),
            onPressed: saveNote,
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 15),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
