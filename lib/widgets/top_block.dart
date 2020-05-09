import 'package:flutter/material.dart';

class TopBlock extends StatelessWidget {
  final Widget child;

  TopBlock({
    @required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      padding: const EdgeInsets.all(40),
      color: Theme.of(context).colorScheme.secondary,
      child: Center(
        child: child,
      ),
    );
  }

}