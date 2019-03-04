import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'globals.dart' as globals;

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  String sendPasswordResetEmail(String email);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth{
  Future<String> signInWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    if(user.isEmailVerified || user == null){
      return user.uid;
    }
    else if (!user.isEmailVerified) {
      FirebaseAuth.instance.signOut();
      return null;
    }
  }

  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    globals.registeredSuccessfully = false;
    FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    globals.registeredSuccessfully = true;
    user.sendEmailVerification();
    return user.uid;
  }

  Future<String> currentUser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<void> signOut() async{
    return FirebaseAuth.instance.signOut();
  }


  String sendPasswordResetEmail(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).catchError((onError) {
      return onError.code;
    });
  }


}