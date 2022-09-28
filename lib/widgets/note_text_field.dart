import 'package:flutter/material.dart';

class NoteTextField extends StatelessWidget {
  final _textEditingController = TextEditingController();
  final String label;
  final String text;

  NoteTextField({required this.label, required this.text});

  TextEditingController getTextEditingController() => _textEditingController;

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = text;
    return TextField(
      decoration: InputDecoration(labelText: label),
      controller: _textEditingController,
    );
  }
}
