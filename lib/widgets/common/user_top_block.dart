import 'package:flutter/material.dart';
import 'package:simpledebts/widgets/common/hero_image_circle.dart';
import 'package:simpledebts/widgets/common/image_lazy_load.dart';

class UserTopBlock extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double fontSize;
  final String imageTag;
  final void Function() onImageTap;

  UserTopBlock({
    @required this.imageUrl,
    @required this.title,
    @required this.imageTag,
    this.fontSize = 24,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onImageTap,
          child: HeroImageCircle(
            diameter: 120,
            image: NetworkImage(imageUrl),
            tag: imageTag,
          )
        ),
        SizedBox(height: 14,),
        Text(
          title,
          style: Theme.of(context).textTheme.headline4.copyWith(
            color: Colors.white,
            fontSize: fontSize
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

}