import 'package:dio/dio.dart';
import 'package:notes_api/notes_api.dart';
import '../server/dio_factory.dart';
import '../server/rest_client.dart';

class RemoteStorageNotesApi extends RemoteApi {
  final RestClient client;

  RemoteStorageNotesApi(this.client);

  @override
  Future<Response<dynamic>> getNotes() {
    return client.getNotes();
  }

  @override
  Future<Response<dynamic>> saveNote(Note noteModel) {
    return client.saveNote(noteModel.id, noteModel.remoteId, noteModel);
  }

  @override
  Future<Response<dynamic>> clearArchived() {
    return client.clearArchived();
  }

  @override
  Future<Response<dynamic>> deleteNote(String id, String remoteId) {
    return client.deleteNote(id, remoteId);
  }
}
