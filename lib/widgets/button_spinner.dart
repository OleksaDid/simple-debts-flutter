import 'package:flutter/material.dart';

class ButtonSpinner extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator()
          ),
        )
      ],
    );
  }

}