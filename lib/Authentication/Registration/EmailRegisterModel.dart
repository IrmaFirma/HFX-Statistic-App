enum EmailRegisterFormType { signIn, register }

class EmailRegisterModel {
  EmailRegisterModel({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.formType = EmailRegisterFormType.signIn,
    this.submitted = false,
  });

  final String email;
  final String password;
  final EmailRegisterFormType formType;
  final bool isLoading;
  final bool submitted;
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


  EmailRegisterModel copyWith({
    final String email,
    final String password,
    final EmailRegisterFormType formType,
    final bool isLoading,
    final bool submitted,
  }) {
    return EmailRegisterModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}