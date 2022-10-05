import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:meta/meta.dart';
part 'note.g.dart';

/// {@template NoteModel}
/// A single NoteModel item.
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Note]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@JsonSerializable(explicitToJson: true)
class Note extends Equatable {
  final String id;
  String remoteId;
  final String title;
  final String body;
  final String noteTime;
  final String imageUrl;
  final bool isArchived;

  Note({
    String? id,
    String? remoteId,
    required this.title,
    required this.body,
    required this.noteTime,
    required this.imageUrl,
    required this.isArchived,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4(),
        remoteId = remoteId ?? '';

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  @override
  String toString() {
    return 'Note{id: $id\nremoteId: $remoteId\nname: $title\nbody: $body\ntime: $noteTime\nimageUrl $imageUrl\nisArchived $isArchived}';
  }

  @override
  List<Object?> get props => [id, title, body, noteTime, imageUrl, isArchived];

  /// Returns a copy of this NoteModel with the given values updated.
  Note copyWith({
    String? id,
    String? remoteId,
    String? title,
    String? body,
    String? noteTime,
    String? imageUrl,
    bool? isArchived,
  }) {
    return Note(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      body: body ?? this.body,
      noteTime: noteTime ?? this.noteTime,
      imageUrl: imageUrl ?? this.imageUrl,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  factory Note.initialNote() =>
      Note(title: '', body: '', noteTime: '', imageUrl: '', isArchived: false);
}
