import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/mixins/screen_widget.dart';
import 'package:simpledebts/providers/auth_provider.dart';

class DebtsListScreen extends StatelessWidget with ScreenWidget {

  static const String routeName = '/debts_list_screen';

  void _logout(BuildContext context) {
    return Provider.of<AuthProvider>(context, listen: false).logout(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: Center(
        child: Text('debts'),
      ),
    );
  }

}