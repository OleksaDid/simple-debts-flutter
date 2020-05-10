import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/mixins/screen_widget.dart';
import 'package:simpledebts/models/user.dart';
import 'package:simpledebts/providers/auth_provider.dart';
import 'package:simpledebts/screens/profile_screen.dart';
import 'package:simpledebts/widgets/top_block.dart';
import 'package:simpledebts/widgets/user_top_block.dart';

class DebtsListScreen extends StatelessWidget with ScreenWidget {

  static const String routeName = '/debts_list_screen';

  void _logout(BuildContext context) {
    return Provider.of<AuthProvider>(context, listen: false).logout(context);
  }

  User _getCurrentUser(BuildContext context) {
    return Provider.of<AuthProvider>(context).authData?.user;
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).pushNamed(ProfileScreen.routeName);
  }

  void _openAddDebtForm() {

  }

  @override
  Widget build(BuildContext context) {
    final user = _getCurrentUser(context);

    return Scaffold(
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
            onPressed: _openAddDebtForm,
          )
        ],
      ),
      body: Column(
        children: [
          if(user != null) TopBlock(
            child: UserTopBlock(
              imageUrl: user.picture,
              title: user.name,
              onImageTap: () => _navigateToProfile(context),
            ),
            color: BlockColor.Green,
          )
        ],
      ),
    );
  }

}