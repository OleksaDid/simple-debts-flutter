import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/screens/debts_list_screen.dart';
import 'package:simpledebts/store/auth.store.dart';

class FacebookLoginButton extends StatelessWidget {
  final authStore = GetIt.instance<AuthStore>();

  Future<void> _loginWithFacebook(BuildContext context) async {
    try {
      final authData = await authStore.facebookLogin();
      if(authData != null) {
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