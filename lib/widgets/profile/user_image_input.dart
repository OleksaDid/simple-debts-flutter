import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';
import 'package:simpledebts/widgets/common/hero_image_circle.dart';

class UserImageInput extends StatefulWidget {
  final Function(File image) onPickImage;
  final String defaultImageUrl;
  final String imageTag;

  UserImageInput({
    @required this.onPickImage,
    @required this.defaultImageUrl,
    @required this.imageTag,
  });

  @override
  _UserImageInputState createState() => _UserImageInputState();
}

class _UserImageInputState extends State<UserImageInput> {
  File _storedImage;
  bool _buttonVisible = false;


  @override
  void initState() {
    super.initState();
    if(_buttonVisible == false) {
      Future.delayed(
        Duration(milliseconds: 200),
          () => setState(() => _buttonVisible = true)
      );
    }
  }

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
      builder: (context) => DialogHelper.getThemedAlertDialog(
        title: Text('Select image source'),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: _takePicture,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              HeroImageCircle(
                tag: widget.imageTag,
                diameter: 140,
                image: _storedImage == null
                    ? NetworkImage(widget.defaultImageUrl,)
                    : FileImage(_storedImage,),
              ),
              AnimatedOpacity(
                opacity: _buttonVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  height: 45,
                  width: 140,
                  color: Colors.black54,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white70,
                  ),
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}