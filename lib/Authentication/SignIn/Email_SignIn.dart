import 'package:flutter/material.dart';
import 'EmailSignInFormChangeNotifier.dart';

class EmailSIgnInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        backgroundColor: Color(0xFF2A3040),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(child: EmailSignInFormChangeNotifier.create(context)),
      ),
      backgroundColor: Color(0xFF1F232E),
    );
  }
}