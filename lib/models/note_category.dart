import 'package:json_annotation/json_annotation.dart';
import 'package:notes_app/models/converter/note_category_converter.dart';
part 'note_category.g.dart';

@JsonSerializable(converters: [NoteCategoryConverter()])
class NoteCategory {
  final String id;
  final String name;

  NoteCategory({required this.id, required this.name});

  factory NoteCategory.fromJson(Map<String, dynamic> json) =>
      _$NoteCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$NoteCategoryToJson(this);
}
