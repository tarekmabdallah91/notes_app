// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:notes_app/home/cubit/note_cubit.dart';
// import 'package:notes_app/pages/add_note_page.dart';

// import 'pages/note_details_page.dart';
// import 'home/view/notes_page.dart';

// void main() async {
//   // Avoid errors caused by flutter upgrade.
// // Importing 'package:flutter/widgets.dart' is required.
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await NotesDb().database();
//   runApp(const NotesApp());
// }

// const appTitle = 'Notes App';

// class NotesApp extends StatelessWidget {
//   const NotesApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create:(context) => NoteCubit(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: appTitle,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         initialRoute: NotesPage.route,
//         routes: {
//           NotesPage.route: (context) => const NotesPage(),
//           NoteDetailsPage.route: (context) => NoteDetailsPage(),
//           AddNotePage.route: (context) => const AddNotePage(),
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/widgets.dart';
import 'package:local_storage_notes_api/local_storage_notes_api.dart';
import 'package:notes_app/bootstrap.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notesApi = LocalStorageNotesApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(notesApi: notesApi);
}