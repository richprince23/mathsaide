import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  User? _user;

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
}
