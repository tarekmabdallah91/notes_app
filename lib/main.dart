import 'package:flutter/widgets.dart';
import 'package:local_storage_notes_api/local_storage_notes_api.dart';
import 'package:notes_app/bootstrap.dart';


Future<void> main() async {
// Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  await NotesDb().database();
  final notesApi = LocalStorageNotesApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(notesApi: notesApi);
}
