import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/screen_widget.dart';
import 'package:simpledebts/models/auth/auth_form.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/services/users_service.dart';
import 'package:simpledebts/screens/base_screen_state.dart';
import 'package:simpledebts/screens/debts_list_screen.dart';
import 'package:simpledebts/widgets/auth/auth_body_widget.dart';
import 'package:simpledebts/widgets/auth/auth_form_widget.dart';
import 'package:simpledebts/widgets/common/top_block.dart';
import 'package:simpledebts/widgets/profile/user_data_form_widget.dart';

class AuthScreen extends StatefulWidget with ScreenWidget {

  static const String routeName = '/auth_screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends BaseScreenState<AuthScreen> {

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
            child: AuthBodyWidget()
          ),
        ],
      )
    );
  }
}