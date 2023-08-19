import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_storage/firebase_storage.dart";

final auth = FirebaseAuth.instance;
final store = FirebaseStorage.instance;

class Auth {
  /// Signup with [email], [password], and [fullName]
  static signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    assert(email != "");
    assert(password.length >= 6);
    assert(fullName != "");
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async => await value.user!.updateDisplayName(fullName));
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
