import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:notes_app/models/note_category.dart';

class NoteCategoryConverter extends JsonConverter<NoteCategory, String> {
  const NoteCategoryConverter();
  @override
  // ignore: avoid_renaming_method_parameters
  NoteCategory fromJson(String jsonNoteCategory) {
    final jsonDate = json.decode(jsonNoteCategory);
    return NoteCategory.fromJson(jsonDate);
  }

  @override
  String toJson(NoteCategory object) {
    return json.encode(object.toJson());
  }
}
