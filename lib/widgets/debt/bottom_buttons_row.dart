import 'package:flutter/material.dart';
import 'package:simpledebts/widgets/debt/debt_screen_bottom_button.dart';

class BottomButtonsRow extends StatelessWidget {
  final DebtScreenBottomButton primaryButton;
  final DebtScreenBottomButton secondaryButton;

  BottomButtonsRow({
    this.primaryButton,
    this.secondaryButton
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if(secondaryButton != null) Expanded(
              child: secondaryButton,
            ),
            if(primaryButton != null) Expanded(
              child: primaryButton,
            ),
          ],
        ),
      ],
    );
  }

}