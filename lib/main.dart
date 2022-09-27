import 'package:flutter/material.dart';
import 'package:notes_app/pages/add_note_page.dart';
import 'package:notes_app/provider/NoteProvider.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/note_details_page.dart';

void main() {
  runApp(const NotesApp());
}

const appTitle = 'Notes App';

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
        routes: {
          NoteDetailsPage.route: (context) => NoteDetailsPage(),
          AddNotePage.route: (context) => AddNotePage(),
        },
      ),
    );
  }
}
