import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/screen_widget.dart';
import 'package:simpledebts/models/auth/auth_form.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/providers/auth_provider.dart';
import 'package:simpledebts/providers/users_provider.dart';
import 'package:simpledebts/screens/debts_list_screen.dart';
import 'package:simpledebts/widgets/auth/auth_form_widget.dart';
import 'package:simpledebts/widgets/common/top_block.dart';
import 'package:simpledebts/widgets/profile/user_data_form_widget.dart';

class AuthScreen extends StatefulWidget with ScreenWidget {

  static const String routeName = '/auth_screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showUserDataForm = false;

  Future<void> _submitAuthForm(AuthForm authForm, bool isLogin) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      if(isLogin) {
        await auth.login(authForm);
        _navigateToMainScreen();
      } else {
        await auth.signUp(authForm);
        setState(() => _showUserDataForm = true);
      }
    } catch(error) {
      // TODO: handle error
      print(error.toString());
      ErrorHelper.showErrorSnackBar(context);
    }
  }

  Future<User> _updateUserData(String name, File image) async {
    try {
      final updatedUser = await Provider.of<UsersProvider>(context, listen: false).updateUserData(name, image);
      _navigateToMainScreen();
      return updatedUser;
    } catch(error) {
      ErrorHelper.handleError(error);
    }
  }

  void _navigateToMainScreen() {
    Navigator.of(context).pushReplacementNamed(DebtsListScreen.routeName);
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
            color: BlockColor.Red,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: SingleChildScrollView(
                child: _showUserDataForm == false
                    ? AuthFormWidget(
                      onSubmit: _submitAuthForm,
                    )
                    : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50.0
                      ),
                      child: UserDataFormWidget(
                        onSubmit: _updateUserData,
                        onSkip: _navigateToMainScreen,
                      ),
                    ),
              ),
            ),
          ),
        ],
      )
    );
  }
}