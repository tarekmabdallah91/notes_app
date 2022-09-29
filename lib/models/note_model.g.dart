// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteModel _$NoteModelFromJson(Map<String, dynamic> jsonMap) => NoteModel(
      id: jsonMap['id'] as String,
      title: jsonMap['title'] as String,
      body: jsonMap['body'] as String,
      noteTime: jsonMap['noteTime'] as String,
      imageUrl: jsonMap['imageUrl'] as String,
      noteCategoryJson: jsonMap['noteCategory'] as String,
    );

// const NoteCategoryConverter()
// .toJson(NoteCategory.fromJson(jsonMap['noteCategory'])),);

// NoteCategory.fromJson(
//     jsonMap['noteCategory'] as Map<String, dynamic>),

// NoteCategory.fromJson(json['noteCategory'] as Map<String, dynamic>),

// const NoteCategoryConverter().fromJson(json['noteCategory']),

// NoteCategory(
//   id: json['noteCategory']['id'],
//   name: json['noteCategory']['name'],
// ),
//NoteCategory.fromJson(json['noteCategory']),
//json['noteCategory'] as NoteCategory,

// NoteCategory.fromJson(json['noteCategory'] as Map<String, dynamic>)
// NoteCategoryConverter().toJson() as String,
// NoteCategoryConverter().toJson(NoteCategory.fromJson(json['noteCategory'])) as String,

Map<String, dynamic> _$NoteModelToJson(NoteModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'noteTime': instance.noteTime,
      'imageUrl': instance.imageUrl,
      'noteCategory': instance.noteCategoryJson,
      // instance.noteCategory.toJson(),
      // const NoteCategoryConverter().toJson(instance.noteCategory),
    };
