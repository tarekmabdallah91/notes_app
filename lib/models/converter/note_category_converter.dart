import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:notes_app/models/note_category.dart';

class NoteCategoryConverter extends JsonConverter<NoteCategory, String> {
  const NoteCategoryConverter();
  @override
  NoteCategory fromJson(String jsonNoteCategory) {
    return json.decode(jsonNoteCategory);
  }

  @override
  String toJson(NoteCategory noteCategory) {
    return json.encode(noteCategory);
  }
}
