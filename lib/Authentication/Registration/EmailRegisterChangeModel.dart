import 'package:flutter/foundation.dart';
import 'package:time_tracker/Services/auth.dart';
import 'EmailRegisterModel.dart';

class EmailRegisterChangeModel with ChangeNotifier {
  EmailRegisterChangeModel({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.formType = EmailRegisterFormType.register,
    this.submitted = false,
    @required this.auth,
  });

  final AuthBase auth;
  String email;
  String password;
  EmailRegisterFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submitButton() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailRegisterFormType.register) {
        await auth.createUserWithEmailPassword(email, password);
      } else {
        await auth.signInWithEmailPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryText {
    return formType == EmailRegisterFormType.register
        ? 'Create an account'
        : 'Sign In';
  }

  String get secondaryText {
    return formType == EmailRegisterFormType.register
        ? 'Have an account? Sign In'
        : 'Need an account? Register';
  }



  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = this.formType == EmailRegisterFormType.register
        ? EmailRegisterFormType.signIn
        : EmailRegisterFormType.register;
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
    EmailRegisterFormType formType,
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