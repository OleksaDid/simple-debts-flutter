import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/providers/auth_provider.dart';
import 'package:simpledebts/screens/debts_list_screen.dart';

class FacebookLoginButton extends StatelessWidget {

  Future<void> _loginWithFacebook(BuildContext context) async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.facebookLogin();
      if(auth.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed(DebtsListScreen.routeName);
      }
    } catch(error) {
      ErrorHelper.showErrorSnackBar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 50,
      buttonColor: const Color.fromRGBO(59, 89, 152, 1),
      child: RaisedButton(
        textColor: Colors.white,
        child: Text(
          'Log in with Facebook',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        onPressed: () => _loginWithFacebook(context),
      ),
    );
  }

}