import 'package:flutter/material.dart';
import 'package:time_tracker/Authentication/Registration/EmailRegisterPage.dart';
import 'package:time_tracker/Authentication/SignIn/Email_SignIn.dart';
import 'package:time_tracker/Authentication/SignIn/SignInPage.dart';
import 'package:time_tracker/Components/ButtonOne.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F232E),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 200),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/trade.png'),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Column(
                      children: [
                        Text('Welcome to HFX Statistic',
                            style: TextStyle(fontSize: 30, color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  ButtonOne(
                      color: Color(0xFF02B28C),
                      text: 'Register with email',
                      textColor: Colors.white,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmailRegisterPage()))),
                  SizedBox(height: 5),
                  FlatButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (context) => EmailSIgnInPage())),
                      child: Text('Already have an account? Sign In!', style: TextStyle(color: Colors.grey.shade200),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}