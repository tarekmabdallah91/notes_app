import 'package:json_annotation/json_annotation.dart';
import 'package:notes_app/models/converter/note_category_converter.dart';
import 'package:notes_app/models/note_category.dart';
part 'note_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NoteModel {
  final String id;
  final String title;
  final String body;
  final String noteTime;
  final String imageUrl;
  final NoteCategory noteCategory;
  // String noteCategoryJson;

  NoteModel({
    required this.id,
    required this.title,
    required this.body,
    required this.noteTime,
    required this.imageUrl,
    required this.noteCategory,
    // required this.noteCategoryJson,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  @override
  String toString() {
    return 'Note{id: $id\nname: $title\nage: $body\nnoteCategory: $noteCategory\ntime: $noteTime\nimageUrl $imageUrl }';
  }
}
