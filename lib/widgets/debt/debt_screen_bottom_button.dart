import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DebtScreenBottomButton extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final Color color;

  DebtScreenBottomButton({
    @required this.onTap,
    @required this.title,
    @required this.color
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      highlightColor: Colors.white10,
      highlightElevation: 0,
      shape: ContinuousRectangleBorder(),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Text(
          title,
          style: TextStyle(
              fontSize: 18,
              color: color
          ),
        ),
      ),
      elevation: 0,
      color: Theme.of(context).scaffoldBackgroundColor,
      onPressed: onTap,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}