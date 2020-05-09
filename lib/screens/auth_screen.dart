import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/error_helper.dart';
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
      print(error.toString());
      ErrorHelper.showErrorSnackBar(context, 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopBlock(
            child: Text(
              'Simple Debts',
              style: Theme.of(context).textTheme.headline2.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: SingleChildScrollView(
                child: AuthFormWidget(
                  onSubmit: _submitAuthForm,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

}