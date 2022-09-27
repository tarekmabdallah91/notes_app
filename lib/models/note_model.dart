class NoteModel {
  String title;
  String body;
  DateTime dateTime = DateTime.now();
  String imageUrl;

  NoteModel({required this.title, required this.body, this.imageUrl = ''});
}
