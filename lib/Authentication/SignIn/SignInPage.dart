import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/Authentication/Registration/RegistrationPage.dart';
import 'package:time_tracker/home/RecordsPage.dart';
import 'Email_SignIn.dart';
import 'package:time_tracker/Components/ButtonOne.dart';
import 'package:time_tracker/Components/Constants.dart';
import 'package:time_tracker/Components/PlatformExceptionDialog.dart';
import 'package:time_tracker/Services/auth.dart';

import 'SignInManager.dart';

class SignInPage extends StatelessWidget {
  SignInPage({@required this.manager, @required this.isLoading});

  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (context) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager, isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (context) => RecordsPage()));
    } catch (e) {
      showSignInError(context, e);
    }
  }

  void showSignInError(BuildContext context, FirebaseAuthException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign In Failed',
      exception: exception,
    ).show(context);
  }

  void signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => EmailSIgnInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F232E),
      appBar: AppBar(
        title: Text('HFX Statistic'),
        centerTitle: true,
        backgroundColor: Color(0xFF2A3040),
        leading: Container(),
      ),
      body: buildContent(context),
    );
  }

  Widget buildContent(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 150),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      buildHeader(),
                    ],
                  ),
                ),
                SizedBox(height: 60),
                ButtonOne(
                  color: Color(0xFF02B28C),
                  text: 'Sign in with Email',
                  textColor: Colors.white,
                  onTap: isLoading ? null : () => signInWithEmail(context),
                ),
                SizedBox(height: 10),
                Text(
                  'or',
                  style: TextStyle(color: Colors.grey, fontSize: 17),
                ),
                SizedBox(height: 10),
                ButtonOne(
                  color: Color(0xFFF7495C),
                  text: 'Go anonymous',
                  textColor: Colors.white,
                  onTap: isLoading ? null : () => _signInAnonymously(context),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => RegistrationPage.create(context),
                    ),
                  ),
                  child: Text('Don\'t have an account? Create one!', style: TextStyle(color: Colors.grey.shade200),),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text('Sign In', style: signInRegister);
  }
}