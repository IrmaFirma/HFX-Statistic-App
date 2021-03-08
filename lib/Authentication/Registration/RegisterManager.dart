import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker/Services/auth.dart';

class RegisterManager {
  RegisterManager({this.auth, this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<MyUser> register(Future<MyUser> Function() registerMethod)async{
    try{
      isLoading.value = true;
      return await registerMethod();
    }catch(e){
      isLoading.value = false;
      rethrow;
    }
  }
}