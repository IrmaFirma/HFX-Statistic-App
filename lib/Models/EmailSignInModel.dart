enum EmailSignInFormType { signIn, register }

class EmailSignInModel {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.formType = EmailSignInFormType.signIn,
    this.submitted = false,
  });

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;
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


  EmailSignInModel copyWith({
    final String email,
    final String password,
    final EmailSignInFormType formType,
    final bool isLoading,
    final bool submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}