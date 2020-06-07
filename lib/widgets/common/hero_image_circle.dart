import 'package:flutter/material.dart';

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