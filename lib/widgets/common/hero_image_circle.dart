import 'package:flutter/material.dart';

class HeroImageCircle extends StatelessWidget {
  final ImageProvider image;
  final String tag;
  final double diameter;


  HeroImageCircle({
    @required this.image,
    @required this.diameter,
    @required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      transitionOnUserGestures: true,
      flightShuttleBuilder: (
          BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
          ) {
        final Hero hero = flightDirection == HeroFlightDirection.push ? toHeroContext.widget : fromHeroContext.widget;
        return hero.child;
      },
      child: CircleAvatar(
        radius: diameter / 2,
        backgroundImage: image,
        backgroundColor: Colors.white,
      )
    );
  }
}