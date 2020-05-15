import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';

mixin SpinnerModal on Widget {
  
  void showSpinnerModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DialogHelper.getThemedDialog(
        child: Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      ),
      barrierDismissible: false
    );
  }

  void hideSpinnerModal(BuildContext context) {
    Navigator.of(context).pop();
  }
} 