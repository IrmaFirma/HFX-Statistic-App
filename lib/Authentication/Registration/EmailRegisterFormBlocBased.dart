import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/home/RecordsPage.dart';
import 'EmailRegisterBloc.dart';
import 'package:time_tracker/Components/ButtonOne.dart';
import 'package:time_tracker/Components/PlatformExceptionDialog.dart';
import 'package:time_tracker/Services/auth.dart';
import 'EmailRegisterModel.dart';

class EmailRegisterFormBlocBased extends StatefulWidget {
  EmailRegisterFormBlocBased({@required this.bloc});

  final EmailRegisterBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailRegisterBloc>(
      create: (context) => EmailRegisterBloc(auth: auth),
      child: Consumer<EmailRegisterBloc>(
        builder: (context, bloc, __) => EmailRegisterFormBlocBased(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailRegisterFormBlocBasedState createState() =>
      _EmailRegisterFormBlocBasedState();
}

class _EmailRegisterFormBlocBasedState
    extends State<EmailRegisterFormBlocBased> {
  //editing controllers for email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //focus nodes for next and done
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  //methods for using focus nodes
  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  Future<void> submitButton() async {
    try {
      await widget.bloc.submitButton();
      Navigator.of(context).pop();
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Registration Failed',
        exception: e,
      ).show(context);
    }
  }

  //changing between text for creating account and signIn
  void toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailRegisterModel model) {
    return [
      emailTextField(model),
      SizedBox(height: 8),
      passwordTextField(model),
      SizedBox(height: 8),
      ButtonOne(
        color: Color(0xFFA379C9),
        textColor: Colors.white,
        text: model.primaryText,
        onTap: submitButton,
      ),
      SizedBox(height: 8),
      FlatButton(
          onPressed: () => !model.isLoading ? toggleFormType : null,
          child: Text(model.secondaryText))
    ];
  }

  TextField passwordTextField(EmailRegisterModel model) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      onChanged: (password) => widget.bloc.updatePassword,
      obscureText: true,
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      onEditingComplete: submitButton,
      textInputAction: TextInputAction.done,
    );
  }

  TextField emailTextField(EmailRegisterModel model) {
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
        onChanged: (email) => widget.bloc.updateEmail,
        textInputAction: TextInputAction.next);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailRegisterModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailRegisterModel(),
        builder: (context, snapshot) {
          final EmailRegisterModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: _buildChildren(model)),
          );
        });
  }
}