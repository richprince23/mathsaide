import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  User? _user;
  UserCredential? userCredential;

  /// Returns the current User
  User get user => _user!;

  /// Sets the current User
  set user(User user) {
    _user = user;
    notifyListeners();
  }

  /// Clears current User
  clearUser() {
    _user = null;
    notifyListeners();
  }

  /// Save the login credentitals to shared Prefs
  /// [email] email of the user
  /// [password] password of the user
  ///
  Future saveUser({required String email, required String password}) async {
    //todo: still testing required
  }
}
