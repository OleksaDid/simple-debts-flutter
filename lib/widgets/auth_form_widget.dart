import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simpledebts/models/auth_form.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthFormWidget extends StatefulWidget {
  final void Function(BuildContext context, AuthForm authForm, bool isLogin) onSubmit;

  AuthFormWidget({
    @required this.onSubmit
  });

  @override
  _AuthFormWidgetState createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final _form = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _privacyPolicyGestureRecognizer = TapGestureRecognizer()
    ..onTap = () => launch('https://simple-debts.flycricket.io/privacy.html');
  final AuthForm _authForm = AuthForm();
  bool _isLogin = true;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _privacyPolicyGestureRecognizer.dispose();
    super.dispose();
  }

  void _submitForm() {
    final isValid = _form.currentState.validate();
    if(isValid) {
      _form.currentState.save();
      widget.onSubmit(context, _authForm, _isLogin);
    } else {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Form is not valid'),
          backgroundColor: Theme.of(context).errorColor,
        )
      );
    }
  }

  void _toggleFormMode() {
    setState(() => _isLogin = !_isLogin);
  }

  String _emailValidator(String value) {
    final emailRegex = RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)");
    if (value.isEmpty || !emailRegex.hasMatch(value)) {
      return 'Invalid email!';
    }
    return null;
  }

  String _passwordValidator(String value) {
    if (value.isEmpty || value.length < 6) {
      return 'Minimum 6 symbols';
    }
    return null;
  }

  String _confirmPasswordValidator(String value) {
    if(!_isLogin && value != _passwordController.text) {
      return 'Passwords do not match!';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
                hintText: 'email'
            ),
            keyboardType: TextInputType.emailAddress,
            validator: _emailValidator,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
            onSaved: (value) => _authForm.email = value.trim(),
          ),
          TextFormField(
            decoration: const InputDecoration(
                hintText: 'password'
            ),
            obscureText: true,
            validator: _passwordValidator,
            focusNode: _passwordFocusNode,
            textInputAction: _isLogin ? TextInputAction.done : TextInputAction.next,
            onFieldSubmitted: !_isLogin ? (_) => FocusScope.of(context).requestFocus(_confirmPasswordFocusNode) : null,
            onSaved: (value) => _authForm.password = value.trim(),
          ),
          Visibility(
            visible: !_isLogin,
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: 'confirm password'
              ),
              controller: _passwordController,
              focusNode: _confirmPasswordFocusNode,
              validator: _confirmPasswordValidator,
              obscureText: true,
            ),
          ),
          SizedBox(height: 20,),
          RaisedButton(
            child: Text(_isLogin ? 'LOGIN' : 'SIGN UP'),
            onPressed: _submitForm,
          ),
          FlatButton(
            child: Text(_isLogin ? 'DON\'T HAVE AN ACCOUNT' : 'ALREADY HAVE AN ACCOUNT'),
            onPressed: _toggleFormMode,
            textColor: Theme.of(context).primaryColor,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'by continuing you accept our ',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color
                  )
                ),
                TextSpan(
                  text: 'privacy policy',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor
                  ),
                  recognizer: _privacyPolicyGestureRecognizer
                )
              ]
            ),
          )
        ],
      ),
    );
  }
}