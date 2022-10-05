import '../notes_api.dart';

abstract class RemoteApi {
  
  Future<dynamic> getNotes();

  Future<dynamic> saveNote(Note noteModel);

  Future<dynamic> clearArchived();

  Future<dynamic> deleteNote(String id, String remoteId);
}
