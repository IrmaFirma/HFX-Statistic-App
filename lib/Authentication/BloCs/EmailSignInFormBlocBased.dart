import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/home/RecordsPage.dart';
import 'EmailSignInBloc.dart';
import 'package:time_tracker/Components/ButtonOne.dart';
import 'package:time_tracker/Components/PlatformExceptionDialog.dart';
import 'package:time_tracker/Services/auth.dart';
import '../Models/EmailSignInModel.dart';


class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({@required this.bloc});

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
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

  //TODO: Dispose for controllers and nodes
  //creating or signing the user using Auth class
  Future<void> submitButton() async {
    try {
      await widget.bloc.submitButton();
      Navigator.of(context).pop();
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign In Failed',
        exception: e,
      ).show(context);
    }
  }

  //changing between text for creating account and signIn
  void toggleFormType(){
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
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

  TextField passwordTextField(EmailSignInModel model) {
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

  TextField emailTextField(EmailSignInModel model) {
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
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
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