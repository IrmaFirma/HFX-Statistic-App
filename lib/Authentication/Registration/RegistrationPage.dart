import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/Authentication/Registration/EmailRegisterPage.dart';
import 'package:time_tracker/Authentication/Registration/RegisterManager.dart';
import 'package:time_tracker/Authentication/SignIn/SignInPage.dart';
import 'package:time_tracker/Components/ButtonOne.dart';
import 'package:time_tracker/Components/Constants.dart';
import 'package:time_tracker/Components/PlatformExceptionDialog.dart';
import 'package:time_tracker/Services/auth.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({@required this.manager, @required this.isLoading});

  final RegisterManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<RegisterManager>(
          create: (context) => RegisterManager(auth: auth, isLoading: isLoading),
          child: Consumer<RegisterManager>(
            builder: (context, manager, _) => RegistrationPage(
              manager: manager, isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void showRegisterError(BuildContext context, FirebaseAuthException exception) {
    PlatformExceptionAlertDialog(
      title: 'Registration Failed',
      exception: exception,
    ).show(context);
  }

  void registerWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => EmailRegisterPage(),
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
                  text: 'Register with Email',
                  textColor: Colors.white,
                  onTap: isLoading ? null : () => registerWithEmail(context),
                ),
                SizedBox(height: 10),
                FlatButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => SignInPage.create(context),
                    ),
                  ),
                  child: Text('Already have an account? Sign in', style: TextStyle(color: Colors.grey.shade200),),
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
    return Text('Register', style: signInRegister);
  }
}