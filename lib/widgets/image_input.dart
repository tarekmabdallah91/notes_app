import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import '../utils/text_utils.dart';

class ImageInput extends StatefulWidget {
  String savedImagePath;
  final Function onSelectImage;
  final tag = 'ImageInput';

  ImageInput({required this.onSelectImage, this.savedImagePath = ''});

  @override
  ImageInputState createState() => ImageInputState();
}

class ImageInputState extends State<ImageInput> {
  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    setState(() {
      widget.savedImagePath = imageFile!.path;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile!.path);
    final savedImage = await File(imageFile.path).copy('${appDir.path}/$fileName');
    TextUtils.printLog(widget.tag, '${appDir.path}/$fileName');
    TextUtils.printLog(widget.tag, savedImage.path);
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: widget.savedImagePath.isEmpty
              ? const Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                )
              : Image.file(
                  File(widget.savedImagePath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.camera),
            label: const Text('Take Picture'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              textStyle: const TextStyle(fontSize: 15),
              elevation: 0,
            ),
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
