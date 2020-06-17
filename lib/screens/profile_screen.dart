import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:simpledebts/mixins/screen_widget.dart';
import 'package:simpledebts/screens/base_screen_state.dart';
import 'package:simpledebts/widgets/profile/user_data_form_widget.dart';

class ProfileScreen extends StatefulWidget with ScreenWidget {

  static const String routeName = '/profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseScreenState<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
              child: UserDataFormWidget(),
            ),
          ),
        ),
      ),
    );
  }
}