import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker/Components/PlatformAwareDialog.dart';

class PlatformExceptionAlertDialog extends PlatformAwareDialog {
  final String title;
  final FirebaseAuthException exception;

  PlatformExceptionAlertDialog({this.title, this.exception})
      : super(
            title: title, content: exception.message, defaultActionText: 'OK');

  static String message(FirebaseAuthException exception){
    print(exception);
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    'invalid-email': 'The email is invalid',
    'user-disabled': 'The entered email has been disabled',
    'wrong-password': 'The password is incorrect',
  };
}
