import 'package:flutter/material.dart';

import '../widgets/image_input.dart';

class AddNotePage extends StatelessWidget {
  static const route = '/AddNotePage';

  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Note'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Place'),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: 15),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
