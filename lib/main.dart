import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:time_tracker/Screens/LandingPage.dart';

import 'package:provider/provider.dart';
import 'package:time_tracker/Services/Database.dart';
import 'package:time_tracker/Services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Database>(
          create: (BuildContext context) => FirestoreDatabase(uid: ''),
        ),
        Provider<AuthBase>(
          create: (BuildContext context) => Auth(),
        ),
      ],
      child: MaterialApp(
        home: LandingPage(),
      ),
    );
  }
}
