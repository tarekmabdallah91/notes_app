import 'package:notes_api/notes_api.dart';

class RemoteRepository {
  final RemoteApi _remoteApi;

  RemoteRepository(this._remoteApi);

  Future<dynamic> getNotes() => _remoteApi.getNotes();

  Future<dynamic> saveNote(Note note) => _remoteApi.saveNote(note);

  Future<dynamic> deleteNote(String id, String remoteId) =>
      _remoteApi.deleteNote(id, remoteId);

  Future<dynamic> clearArchived() => _remoteApi.clearArchived();
}
