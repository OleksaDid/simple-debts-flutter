import 'package:flutter/material.dart';

class DismissBackground extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15
      ),
      color: Theme.of(context).errorColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.delete, color: Colors.white, size: 40,),
          ],
        ),
      ),
    );
  }

}