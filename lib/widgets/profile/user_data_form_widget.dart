import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/store/auth.store.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';
import 'package:simpledebts/widgets/profile/user_image_input.dart';

class UserDataFormWidget extends StatefulWidget {
  final Future<User> Function(String name, File image) onSubmit;
  final void Function() onSkip;

  UserDataFormWidget({
    @required this.onSubmit,
    this.onSkip
  });

  @override
  _UserDataFormWidgetState createState() => _UserDataFormWidgetState();
}

class _UserDataFormWidgetState extends State<UserDataFormWidget> with SpinnerStoreUse {
  final authStore = GetIt.instance<AuthStore>();
  final _form = GlobalKey<FormState>();
  File _userImage;
  String _name;

  @override
  void initState() {
    _name = _defaultName;
    super.initState();
  }

  void _setImage(File image) {
    _userImage = image;
  }

  String _nameValidator(String value) {
    if(value.isEmpty || value.length < 3) {
      return 'Invalid name';
    }
    return null;
  }

  String get _defaultName {
    return authStore.currentUser.name;
  }

  bool get _isFormChanged {
    return _userImage != null || _name != _defaultName;
  }

  Future<void> _submitForm() async {
    final isValid = _form.currentState.validate();
    if(!isValid) {
      throw 'Invalid form';
    }
    FocusScope.of(context).unfocus();
    _form.currentState.save();
    if(!_isFormChanged) {
      return widget.onSkip != null ? widget.onSkip() : null;
    }
    showSpinner();
    try {
      final user = await widget.onSubmit(_name, _userImage);
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Your profile was successfully updated'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ));
      authStore.updateUserData(user);
    } catch(error) {
      ErrorHelper.handleError(error);
    }
    hideSpinner();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          Observer(
            builder: (context) => UserImageInput(
              onPickImage: _setImage,
              defaultImageUrl: authStore.currentUser.picture,
            ),
          ),
          SizedBox(height: 15,),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'name',
            ),
            validator: _nameValidator,
            initialValue: _defaultName,
            textAlign: TextAlign.center,
            onSaved: (value) => _name = value.trim(),
          ),
          SizedBox(height: 15,),
          spinnerContainer(
            spinner: ButtonSpinner(),
            replacement: FlatButton(
              child: Text(
                'SAVE',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              textColor: Theme.of(context).primaryColor,
              onPressed: _submitForm,
            ),
          )
        ],
      ),
    );
  }
}