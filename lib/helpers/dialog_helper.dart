import 'package:flutter/material.dart';

class DialogHelper {

  static Dialog getThemedDialog({
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

  static AlertDialog getThemedAlertDialog({
    Key key,
    Color backgroundColor,
    EdgeInsets insetPadding,
    Clip clipBehavior = Clip.none,
    Widget title,
    List<Widget> actions,
    IconData icon,
    Color iconColor
  }) => AlertDialog(
    key: key,
    backgroundColor: backgroundColor,
    insetPadding: insetPadding,
    clipBehavior: clipBehavior,
    title: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(icon != null) Icon(
          icon,
          size: 40,
          color: iconColor,
        ),
        if(icon != null) SizedBox(height: 10,),
        Container(
          width: 270,
          child: title
        ),
      ],
    ),
    actions: actions,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
    ),
  );

  static Future<bool> showDeleteDialog(BuildContext context, String title) {
    return showDialog<bool>(
        context: context,
        builder: (context) => getThemedAlertDialog(
          icon: Icons.error_outline,
          iconColor: Theme.of(context).accentColor,
          title: Text(title),
          actions: [
            FlatButton(
              child: Text('NO'),
              textColor: Theme.of(context).accentColor,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text('YES'),
              textColor: Theme.of(context).accentColor,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        )
    );
  }
}