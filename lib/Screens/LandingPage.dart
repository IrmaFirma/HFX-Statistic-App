import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/Services/auth.dart';
import 'package:time_tracker/Services/Database.dart';
import 'package:time_tracker/home/HomePage.dart';
import 'package:time_tracker/home/RecordsPage.dart';
import 'WelcomeScreen.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<MyUser>(
        stream: auth.onAuthStateChanged,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            MyUser user = snapshot.data;
            if (user == null) {
              return WelcomeScreen();
            }
            return Provider<MyUser>.value(
              value: user,
              child: Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: HomePage(),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
