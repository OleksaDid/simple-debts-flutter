import 'package:flutter/material.dart';

enum BlockColor {Green, Red}

class TopBlock extends StatelessWidget {
  final Widget child;
  final BlockColor color;

  const TopBlock({
    @required this.child,
    @required this.color,
  });

  Color getMainColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return color == BlockColor.Green ? scheme.primary : scheme.secondary;
  }

  Color getVariantColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return color == BlockColor.Green ? scheme.primaryVariant : scheme.secondaryVariant;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 224,
          padding: const EdgeInsets.symmetric(
            horizontal: 40
          ),
          color: getMainColor(context),
          child: Center(
            child: child,
          ),
        ),
        Container(
          height: 10,
          color: getVariantColor(context),
        )
      ],
    );
  }

}