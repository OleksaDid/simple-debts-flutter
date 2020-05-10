import 'package:flutter/material.dart';

class ImageLazyLoad extends StatelessWidget {
  final ImageProvider image;

  ImageLazyLoad(this.image);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
        ),
        Center(
          child: CircularProgressIndicator(),
        ),
        FadeInImage(
          image: image,
          fit: BoxFit.cover,
          placeholder: AssetImage('assets/images/transparent_image.png'),
        )
      ],
    );
  }

}