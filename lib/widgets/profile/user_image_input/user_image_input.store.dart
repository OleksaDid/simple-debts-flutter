import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';

class UserImageInputStore {
  BehaviorSubject<File> _storedImage = BehaviorSubject();
  BehaviorSubject<bool> _buttonVisible = BehaviorSubject.seeded(false);

  UserImageInputStore() {
    _setupAnimation();
  }

  Stream<bool> get buttonVisible$ => _buttonVisible.stream;
  Stream<File> get storedImage$ => _storedImage.stream;


  Future<File> takePicture(BuildContext context) async {
    final imageSource = await _getImageSource(context);
    if(imageSource == null) {
      return null;
    }
    final image = await ImagePicker.pickImage(
        source: imageSource,
        maxWidth: 200,
        imageQuality: 50
    );
    if(image == null) {
      return null;
    }
    _storedImage.add(image);

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    return  image.copy('${appDir.path}/$fileName');
  }

  Future<ImageSource> _getImageSource(BuildContext context) {
    return showDialog<ImageSource>(
        context: context,
        builder: (context) => DialogHelper.getThemedAlertDialog(
          title: const Text('Select image source'),
          icon: Icons.image,
          iconColor: Theme.of(context).primaryColor,
          actions: [
            FlatButton(
              child: Text('GALLERY'),
              textColor: Theme.of(context).primaryColor,
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            FlatButton(
              child: Text('CAMERA'),
              textColor: Theme.of(context).primaryColor,
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            )
          ],
        )
    );
  }

  void _setupAnimation() => Future.delayed(
      Duration(milliseconds: 200),
      () => _buttonVisible.add(true)
  );
}