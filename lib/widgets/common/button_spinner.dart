import 'package:flutter/material.dart';

class ButtonSpinner extends StatelessWidget {
  final double radius;

  ButtonSpinner({
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: SizedBox(
              height: radius,
              width: radius,
              child: CircularProgressIndicator()
          ),
        )
      ],
    );
  }

}