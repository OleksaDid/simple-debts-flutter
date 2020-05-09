import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class UserImageInput extends StatefulWidget {
  final Function(File image) onPickImage;
  final String defaultImageUrl;

  UserImageInput({
    @required this.onPickImage,
    @required this.defaultImageUrl,
  });

  @override
  _UserImageInputState createState() => _UserImageInputState();
}

class _UserImageInputState extends State<UserImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    final imageSource = await _getImageSource();
    if(imageSource == null) {
      return;
    }
    final image = await ImagePicker.pickImage(
      source: imageSource,
      maxWidth: 200,
      imageQuality: 50
    );
    if(image == null) {
      return;
    }
    setState(() => _storedImage = image);

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final savedImage = await image.copy('${appDir.path}/$fileName');
    widget.onPickImage(savedImage);
  }

  Future<ImageSource> _getImageSource() {
    return showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select image source'),
        actions: [
          FlatButton(
            child: Text('Gallery'),
            onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
          FlatButton(
            child: Text('Camera'),
            onPressed: () => Navigator.of(context).pop(ImageSource.camera),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: _takePicture,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: _storedImage == null
                    ? Image.network(widget.defaultImageUrl)
                    : Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              alignment: Alignment.center,
            ),
            Container(
              height: 45,
              width: 140,
              color: Colors.black54,
              child: Icon(
                Icons.camera_alt,
                color: Colors.white70,
              ),
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
    );
  }
}