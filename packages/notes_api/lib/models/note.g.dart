// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteModelFromJson(Map<String, dynamic> json) => Note(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      noteTime: json['noteTime'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$NoteModelToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'noteTime': instance.noteTime,
      'imageUrl': instance.imageUrl,
    };
