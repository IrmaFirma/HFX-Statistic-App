import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../Models/EmailSignInModel.dart';
import 'package:time_tracker/Services/auth.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../Models/EmailSignInModel.dart';
import 'package:time_tracker/Services/auth.dart';
import 'package:flutter/material.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});

  final AuthBase auth;
  final _modelSubject = BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());
  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;
  EmailSignInModel get _model => _modelSubject.value;

  void dispose() {
    _modelSubject.close();
  }

  //moving submit logic form form to bloc
  Future<void> submitButton() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailPassword(_model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  //is like the set method
  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    //update model add updated model to modelController
    _modelSubject.value = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
  }
}