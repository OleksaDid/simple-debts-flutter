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
            color: Theme.of(context).primaryColor
          ),
        ),
        FadeInImage(
          width: double.infinity,
          image: image,
          fit: BoxFit.cover,
          placeholder: AssetImage('assets/images/transparent_image.png'),
        )
      ],
    );
  }

}