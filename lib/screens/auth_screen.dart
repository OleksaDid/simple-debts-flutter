import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/mixins/screen_widget.dart';
import 'package:simpledebts/models/auth_form.dart';
import 'package:simpledebts/providers/auth_provider.dart';
import 'package:simpledebts/screens/debts_list_screen.dart';
import 'package:simpledebts/widgets/auth_form_widget.dart';
import 'package:simpledebts/widgets/top_block.dart';

class AuthScreen extends StatelessWidget with ScreenWidget {

  static const String routeName = '/auth_screen';

  Future<void> _submitAuthForm(BuildContext context, AuthForm authForm, bool isLogin) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      if(isLogin) {
        await auth.login(authForm);
      } else {
        await auth.signUp(authForm);
      }
      Navigator.of(context).pushReplacementNamed(DebtsListScreen.routeName);
    } catch(error) {
      // TODO: handle error
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Sometihng went wrong'),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopBlock(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AuthFormWidget(
                  onSubmit: _submitAuthForm,
                ),
              ),
            ),
          )
        ],
      )
    );
  }

}