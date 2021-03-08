import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/Authentication/SignIn/SignInPage.dart';
import 'package:time_tracker/Components/Avatar.dart';
import 'package:time_tracker/Components/PlatformAwareDialog.dart';
import 'package:time_tracker/Services/auth.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (context) => SignInPage.create(context)));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAwareDialog(
      title: 'Logout',
      content: 'Are you sure that you want to Logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    return Scaffold(
      backgroundColor: Color(0xFF1F232E),
      appBar: AppBar(
        title: Text('Account',  style: TextStyle(color: Color(0xFFC6D5E9))),
        backgroundColor: Color(0xFF2A3040),
        leading: Container(),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFC6D5E9),
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(user),
        ),
      ),
    );
  }

  Widget _buildUserInfo(MyUser user) {
    return Column(
      children: [
        Avatar(
          photoURL: user.photoURL,
          radius: 50
        ),
        SizedBox(height: 2),
        if(user.displayName != null)
          Text(
            user.displayName,
            style: TextStyle(color: Colors.white54),
          ),
        SizedBox(height: 2),
      ],
    );
  }
}
