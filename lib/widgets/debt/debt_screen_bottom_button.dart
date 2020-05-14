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
      padding: const EdgeInsets.all(14),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            color: Colors.white
        ),
      ),
      elevation: 0,
      color: color,
      onPressed: onTap,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}