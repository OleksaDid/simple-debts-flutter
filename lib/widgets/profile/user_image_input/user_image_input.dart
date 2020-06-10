import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simpledebts/widgets/common/hero_image_circle.dart';
import 'package:simpledebts/widgets/profile/user_image_input/user_image_input.store.dart';

class UserImageInput extends StatelessWidget {
  final UserImageInputStore _userImageInputStore = UserImageInputStore();
  final Function(File image) onPickImage;
  final String defaultImageUrl;
  final String imageTag;

  UserImageInput({
    @required this.onPickImage,
    @required this.defaultImageUrl,
    @required this.imageTag,
  });


  Future<void> _takePicture(BuildContext context) async {
    final picture = await _userImageInputStore.takePicture(context);
    if(picture != null) {
      onPickImage(picture);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () => _takePicture(context),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              StreamBuilder<File>(
                stream: _userImageInputStore.storedImage$,
                builder: (context, snapshot) {
                  final image = snapshot.data;

                  return HeroImageCircle(
                    tag: imageTag,
                    diameter: 140,
                    image: image == null
                        ? NetworkImage(defaultImageUrl,)
                        : FileImage(image),
                  );
                }
              ),
              StreamBuilder<bool>(
                stream: _userImageInputStore.buttonVisible$,
                builder: (context, snapshot) {
                  final showButton = snapshot.data ?? false;
                  return AnimatedOpacity(
                    opacity: showButton ? 1.0 : 0.0,
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
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}