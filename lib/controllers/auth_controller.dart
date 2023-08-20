import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";

final auth = FirebaseAuth.instance;
final store = FirebaseStorage.instance;

class Auth {
  /// Signup with [email], [password], and [fullName]
  static Future signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    assert(email != "");
    assert(password.length >= 6);
    assert(fullName != "");
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password)
          .then((value) async =>
              await value.user!.updateDisplayName(fullName.trim()));
    } on FirebaseAuthException {
      rethrow;
    }
  }

  ///Login with Email and Password
  ///
  ///Returns [UserCredential]
  static Future login({
    required String email,
    required String password,
  }) async {
    assert(email != "");
    assert(password.length >= 6);
    try {
      return await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  //log out
  static Future logout() async {
    await auth.signOut();
  }
}
