import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/services/users_service.dart';
import 'package:simpledebts/store/auth.store.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';
import 'package:simpledebts/widgets/profile/user_image_input.dart';

class UserDataFormWidget extends StatefulWidget {
  final void Function() onSuccess;
  final void Function() onSkip;

  UserDataFormWidget({
    this.onSuccess,
    this.onSkip
  });

  @override
  _UserDataFormWidgetState createState() => _UserDataFormWidgetState();
}

class _UserDataFormWidgetState extends State<UserDataFormWidget> with SpinnerStoreUse {
  final _authStore = GetIt.instance<AuthStore>();
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
    return _authStore.currentUser.name;
  }

  bool get _isFormChanged {
    return _userImage != null || _name != _defaultName;
  }

  Future<void> _submitForm() async {
    final isValid = _form.currentState.validate();
    if(!isValid) {
      return ErrorHelper.showErrorSnackBar(context, "Invalid form");
    }
    FocusScope.of(context).unfocus();
    _form.currentState.save();
    if(!_isFormChanged) {
      return widget.onSkip != null ? widget.onSkip() : null;
    }
    showSpinner();
    try {
      final user = await GetIt.instance<UsersService>().updateUserData(_name, _userImage);
      print(user.name);
      if(widget.onSuccess != null) {
        widget.onSuccess();
      }
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Your profile was successfully updated'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ));
      _authStore.updateUserData(user);
    } on Failure catch(error) {
      ErrorHelper.showErrorSnackBar(context, error.message);
    }
    hideSpinner();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          UserImageInput(
            imageTag: _authStore.currentUser.id,
            onPickImage: _setImage,
            defaultImageUrl: _authStore.currentUser.picture,
          ),
          SizedBox(height: 15,),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'type your name',
            ),
            validator: _nameValidator,
            initialValue: _defaultName,
            textAlign: TextAlign.center,
            onSaved: (value) => _name = value.trim(),
          ),
          SizedBox(height: 35,),
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