import 'package:flutter/material.dart';
import 'package:simpledebts/widgets/debt/debt_screen_bottom_button.dart';

class BottomButtonsRow extends StatelessWidget {
  final DebtScreenBottomButton primaryButton;
  final DebtScreenBottomButton secondaryButton;

  BottomButtonsRow({
    @required this.primaryButton,
    @required this.secondaryButton
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: secondaryButton,
        ),
        Expanded(
          child: primaryButton,
        ),
      ],
    );
  }

}