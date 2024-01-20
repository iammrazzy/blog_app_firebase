import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;

  // user SignIn
  Future<void> userSignIN(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('User not found...!');
        showMSG('User not found...!', Colors.red);
      } else if (e.code == 'wrong-password') {
        print('Wrong passord...!');
        showMSG('Wrong password...!', Colors.red);
      }
    }
  }

  // show message
  void showMSG(String msg, Color color) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
