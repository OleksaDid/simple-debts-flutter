import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/screen_widget.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/providers/users_provider.dart';
import 'package:simpledebts/widgets/profile/user_data_form_widget.dart';

class ProfileScreen extends StatelessWidget with ScreenWidget {

  static const String routeName = '/profile_screen';

  Future<User> _updateUserInfo(BuildContext context, String name, File image) async {
    try {
      final User user = await Provider.of<UsersProvider>(context, listen: false).updateUserData(name, image);
      return user;
    } catch(error) {
      ErrorHelper.handleError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update user profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        textTheme: Theme.of(context).textTheme,
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.headline1.color
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            alignment: Alignment.center,
            child: UserDataFormWidget(
              onSubmit: (String name, File image) => _updateUserInfo(context, name, image),
            ),
          ),
        ),
      ),
    );
  }

}