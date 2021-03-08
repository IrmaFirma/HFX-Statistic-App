import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  MyUser({this.uid, this.photoURL, this.displayName});

  final String uid;
  final String photoURL;
  final String displayName;
}

abstract class AuthBase {
  Future<MyUser> currentUser();

  Future<MyUser> signInAnonymously();

  Future<void> signOut();

  Stream<MyUser> get onAuthStateChanged;

  Future<MyUser> signInWithEmailPassword(String email, String password);

  Future<MyUser> createUserWithEmailPassword(String email, String password);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  MyUser _userfromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return MyUser(
        uid: user.uid, displayName: user.displayName, photoURL: user.photoURL);
  }

  @override
  Stream<MyUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userfromFirebase);
  }

  @override
  Future<MyUser> signInWithEmailPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userfromFirebase(authResult.user);
  }

  @override
  Future<MyUser> createUserWithEmailPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userfromFirebase(authResult.user);
  }

  @override
  Future<MyUser> currentUser() async {
    final user = await _firebaseAuth.currentUser;
    return _userfromFirebase(user);
  }

  @override
  Future<MyUser> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userfromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
