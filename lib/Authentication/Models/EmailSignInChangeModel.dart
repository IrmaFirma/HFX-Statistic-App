import 'package:flutter/foundation.dart';
import 'package:time_tracker/Services/auth.dart';
import 'EmailSignInModel.dart';

class EmailSignInChangeModel with ChangeNotifier {
  EmailSignInChangeModel({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.formType = EmailSignInFormType.signIn,
    this.submitted = false,
    @required this.auth,
  });

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submitButton() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailPassword(email, password);
      } else {
        await auth.createUserWithEmailPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an account';
  }

  String get secondaryText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign In';
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
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

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}