class NoteModel {
  String id;
  String title;
  String body;
  String noteTime;
  String imageUrl;

  NoteModel({
    required this.id,
    required this.title,
    required this.body,
    required this.noteTime,
    this.imageUrl = '',
  });

  // Convert a Note into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'noteTime': noteTime,
      'imageUrl': imageUrl,
    };
  }

  // Implement toString to make it easier to see information about
  // each note when using the print statement.
  @override
  String toString() {
    return 'Note{id: $id\nname: $title\nage: $body\ntime: $noteTime\nimageUrl $imageUrl }';
  }
}
