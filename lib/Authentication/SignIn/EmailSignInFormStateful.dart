import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/Components/ButtonOne.dart';
import 'package:time_tracker/Components/PlatformExceptionDialog.dart';
import 'package:time_tracker/Services/auth.dart';
import 'package:time_tracker/home/RecordsPage.dart';
import '../Models/EmailSignInModel.dart';

//enum for creating acc and signIn

class EmailSignInFormStateful extends StatefulWidget {
  @override
  _EmailSignInFormStatefulState createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  //editing controllers for email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //getters for password fields
  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  //focus nodes for next and done
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  //methods for using focus nodes
  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  //enum variable
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  //creating or signing the user using Auth class
  Future<void> submitButton() async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailPassword(_email, _password);
      } else {
        await auth.createUserWithEmailPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign In Failed',
        exception: e,
      ).show(context);
    }
  }

  //changing between text for creating account and signIn
  void toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final _primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an account';
    final _secondary = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign In';
    return [
      emailTextField(),
      SizedBox(height: 8),
      passwordTextField(),
      SizedBox(height: 8),
      ButtonOne(
        color: Color(0xFFA379C9),
        textColor: Colors.white,
        text: _primaryText,
        onTap: submitButton,
      ),
      SizedBox(height: 8),
      FlatButton(
          onPressed: () {
            toggleFormType();
          },
          child: Text(_secondary))
    ];
  }

  TextField passwordTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      obscureText: true,
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      onEditingComplete: submitButton,
      textInputAction: TextInputAction.done,
    );
  }

  TextField emailTextField() {
    return TextField(
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'hfx@hfx.com',
        ),
        controller: _emailController,
        focusNode: _emailFocusNode,
        autocorrect: false,
        onEditingComplete: _emailEditingComplete,
        keyboardType: TextInputType.emailAddress,
        onChanged: (email) {
          updateState();
        },
        textInputAction: TextInputAction.next);
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _buildChildren()),
    );
  }
}
