import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:simpledebts/mixins/screen_widget.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/screens/base_screen_state.dart';
import 'package:simpledebts/screens/profile_screen.dart';
import 'package:simpledebts/widgets/add_debt/add_debt_dialog.dart';
import 'package:simpledebts/widgets/debt_list/debt_list_widget.dart';
import 'package:simpledebts/widgets/common/top_block.dart';
import 'package:simpledebts/widgets/common/user_top_block.dart';

class DebtsListScreen extends StatefulWidget with ScreenWidget {

  static const String routeName = '/debts_list_screen';

  @override
  _DebtsListScreenState createState() => _DebtsListScreenState();
}

class _DebtsListScreenState extends BaseScreenState<DebtsListScreen> {
  Stream<User> _currentUser$;

  void _logout(BuildContext context) {
    authStore.logout();
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).pushNamed(ProfileScreen.routeName);
  }

  void _openAddDebtForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddDebtDialog()
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_currentUser$ == null) {
      _currentUser$ = authStore.currentUser$;
    }

    return FocusWatcher(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _openAddDebtForm(context),
            )
          ],
        ),
        body: Column(
          children: [
            StreamBuilder<User>(
              stream: _currentUser$,
              builder: (context, snapshot) {
                final user = snapshot.data ?? authStore.currentUser;
                if(user == null) {
                  return SizedBox();
                }
                return TopBlock(
                  child: UserTopBlock(
                    imageUrl: user.picture,
                    imageTag: user.id,
                    title: user.name,
                    onImageTap: () => _navigateToProfile(context),
                    fontSize: 34,
                  ),
                  color: BlockColor.Green,
                );
              }
            ),
            Expanded(
                child: DebtListWidget()
            )
          ],
        ),
      ),
    );
  }
}