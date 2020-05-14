import 'package:flutter/material.dart';

class DialogHelper {

  static getThemedDialog({
    Key key,
    Color backgroundColor,
    Duration insetAnimationDuration = const Duration(milliseconds: 100),
    Curve insetAnimationCurve = Curves.decelerate,
    EdgeInsets insetPadding,
    Clip clipBehavior = Clip.none,
    Widget child
  }) => Dialog(
    key: key,
    backgroundColor: backgroundColor,
    insetAnimationDuration: insetAnimationDuration,
    insetAnimationCurve: insetAnimationCurve,
    insetPadding: insetPadding,
    clipBehavior: clipBehavior,
    child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 30.0,
          horizontal: 40.0,
        ),
        child: Container(
          width: 240,
          child: child
        )
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
    ),
  );


}