import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker/Services/auth.dart';

class SignInManager {
  SignInManager({this.auth, this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<MyUser> signIn(Future<MyUser> Function() signInMethod)async{
    try{
      isLoading.value = true;
      return await signInMethod();
    }catch(e){
      isLoading.value = false;
      rethrow;
    }
  }
  Future<MyUser> signInAnonymously() async => await signIn(auth.signInAnonymously);
}