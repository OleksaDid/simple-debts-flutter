import 'package:flutter/material.dart';
import 'package:simpledebts/widgets/common/image_lazy_load.dart';

class HeroImageCircle extends StatelessWidget {
  final String imageUrl;
  final String tag;
  final double diameter;


  HeroImageCircle({
    @required this.imageUrl,
    @required this.diameter,
    @required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      transitionOnUserGestures: true,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: (diameter + 6) / 2,
        child: CircleAvatar(
          radius: diameter / 2,
          backgroundImage: NetworkImage(imageUrl),
          backgroundColor: Colors.white,
        ),
      )
    );
  }
}