import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_state.dart';
import 'package:simpledebts/providers/auth_provider.dart';
import 'package:simpledebts/widgets/button_spinner.dart';
import 'package:simpledebts/widgets/user_image_input.dart';

class UserDataFormWidget extends StatefulWidget {
  final Future<void> Function(String name, File image) onSubmit;
  final void Function() onSkip;

  UserDataFormWidget({
    @required this.onSubmit,
    this.onSkip
  });

  @override
  _UserDataFormWidgetState createState() => _UserDataFormWidgetState();
}

class _UserDataFormWidgetState extends State<UserDataFormWidget> with SpinnerState {
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

  String _getDefaultImageUrl() {
    return Provider.of<AuthProvider>(context).authData.user.picture;
  }

  String _nameValidator(String value) {
    if(value.isEmpty || value.length < 3) {
      return 'Invalid name';
    }
    return null;
  }

  String get _defaultName {
    return Provider.of<AuthProvider>(context, listen: false).authData.user.name;
  }

  bool get _isFormChanged {
    return _userImage != null || _name != _defaultName;
  }

  Future<void> _submitForm() async {
    final isValid = _form.currentState.validate();
    if(!isValid) {
      return ErrorHelper.showErrorSnackBar(context, 'Invalid form');
    }
    _form.currentState.save();
    if(!_isFormChanged) {
      return widget.onSkip != null ? widget.onSkip() : null;
    }
    showSpinner();
    try {
      await widget.onSubmit(_name, _userImage);
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
          UserImageInput(
            onPickImage: _setImage,
            defaultImageUrl: _getDefaultImageUrl(),
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
          Visibility(
            visible: !spinnerVisible,
            child: FlatButton(
              child: Text(
                'SAVE',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              textColor: Theme.of(context).primaryColor,
              onPressed: _submitForm,
            ),
            replacement: ButtonSpinner()
          )
        ],
      ),
    );
  }
}