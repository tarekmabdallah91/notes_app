// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) => NoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      noteTime: json['noteTime'] as String,
      imageUrl: json['imageUrl'] as String,
      noteCategory:
          NoteCategory.fromJson(json['noteCategory'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NoteModelToJson(NoteModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'noteTime': instance.noteTime,
      'imageUrl': instance.imageUrl,
      'noteCategory': instance.noteCategory.toJson(),
    };
