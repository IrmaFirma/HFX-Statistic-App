
import 'package:flutter/material.dart';
import 'package:time_tracker/Authentication/Registration/EmailRegisterFormChangeNotifier.dart';


class EmailRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Color(0xFF2A3040),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(child: EmailRegisterFormChangeNotifier.create(context)),
      ),
      backgroundColor: Color(0xFF1F232E),
    );
  }
}