import 'package:flutter/widgets.dart';
import 'package:local_storage_notes_api/local_storage_notes_api.dart';
import 'package:notes_app/bootstrap.dart';
import 'package:remote_storage_notes_api/remote_storage_notes_api.dart';
import 'package:remote_storage_notes_api/server/dio_factory.dart';
import 'package:remote_storage_notes_api/server/rest_client.dart';

Future<void> main() async {
// Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  await NotesDb().database();
  final notesApi = LocalStorageNotesApi(
    plugin: await SharedPreferences.getInstance(),
  );
  final sessionApi = LocalStorageSession(
    plugin: await SharedPreferences.getInstance(),
  );

  final dio = await DioFactory().getDio();
  final RestClient client = RestClient(dio);
  RemoteStorageNotesApi remoteStorageNotesApi = RemoteStorageNotesApi(client);

  bootstrap(notesApi: notesApi, sessionApi: sessionApi, remoteApi: remoteStorageNotesApi);
}
