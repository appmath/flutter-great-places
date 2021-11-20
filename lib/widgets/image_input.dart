import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput({required this.onSelectImage});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (image != null) {
      File imageFile = File(image.path);
      setState(() {
        _storedImage = imageFile;
      });
      Directory appDir = await pathProvider.getApplicationDocumentsDirectory();
      var fileName = path.basename(imageFile.path);
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');
      widget.onSelectImage(savedImage);
    }

    // imageFile.copy()
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.primary,
                minimumSize: Size(0, 100)),
            label: Text('Take Picture'),
            icon: Icon(Icons.camera),
            onPressed: _takePicture,
          ),
        )
      ],
    );
  }
}
