import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:simpledebts/mixins/screen_widget.dart';
import 'package:simpledebts/screens/base_screen_state.dart';
import 'package:simpledebts/widgets/auth/auth_body_widget.dart';
import 'package:simpledebts/widgets/common/top_block.dart';

class AuthScreen extends StatefulWidget with ScreenWidget {

  static const String routeName = '/auth_screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends BaseScreenState<AuthScreen> {

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            TopBlock(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Text(
                  'Simple Debts',
                  style: Theme.of(context).textTheme.headline2.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              color: BlockColor.Green,
            ),
            Expanded(
              child: AuthBodyWidget()
            ),
          ],
        )
      ),
    );
  }
}