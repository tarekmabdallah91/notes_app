import 'package:notes_api/notes_api.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

const String baseUrl = 'https://alarmscontroller.firebaseio.com/';

@RestApi(baseUrl: baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/notes.json")
  Future<Response<dynamic>> getNotes();

  @POST('/notes/{id}/{remoteId}.json')
  Future<Response<dynamic>> saveNote(@Path("id") String id, @Path("remoteId") String remoteId, Note noteModel,);

  @DELETE('/notes.json')
  Future<Response<dynamic>> clearArchived();

  @DELETE('/notes/{id}/{remoteId}.json')
  Future<Response<dynamic>> deleteNote(
    @Path("id") String id,
    @Path("remoteId") String remoteId,
  );
}
