import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/Components/ButtonOne.dart';
import 'package:time_tracker/Components/PlatformExceptionDialog.dart';
import 'package:time_tracker/Services/auth.dart';
import 'package:time_tracker/home/RecordsPage.dart';
import '../Models/EmailSignInChangeModel.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({@required this.model});

  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) =>
            EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  //editing controllers for email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //focus nodes for next and done
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  //methods for using focus nodes
  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  //TODO: Dispose for controllers and nodes
  //creating or signing the user using Auth class
  Future<void> submitButton() async {
    try {
      await model.submitButton();
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
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      emailTextField(),
      SizedBox(height: 8),
      passwordTextField(),
      SizedBox(height: 8),
      ButtonOne(
        color: Color(0xFF02B28C),
        textColor: Colors.white,
        text: model.primaryText,
        onTap: submitButton,
      ),
      SizedBox(height: 8),
      FlatButton(
          onPressed: () => model.toggleFormType(),
          child: Text(model.secondaryText))
    ];
  }

  TextField passwordTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      onChanged: (password) => model.updatePassword(password),
      obscureText: true,
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      onEditingComplete: () => model.submitButton(),
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
        onEditingComplete: () => _emailEditingComplete(),
        keyboardType: TextInputType.emailAddress,
        onChanged: (email) => model.updateEmail(email),
        textInputAction: TextInputAction.next);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFC6D5E9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren()),
      ),
    );
  }
}
