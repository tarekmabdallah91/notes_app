import 'package:flutter/material.dart';

class AddNoteBtn extends StatelessWidget {
  final String label;
  final IconData iconDate;
  final Function onTapBtn;

  const AddNoteBtn(
      {required this.label, required this.iconDate, required this.onTapBtn});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(iconDate),
      label: Text(label),
      onPressed: () => onTapBtn(),
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 15),
        elevation: 0,
      ),
    );
  }
}
