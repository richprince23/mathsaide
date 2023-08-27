import "dart:io";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";

final auth = FirebaseAuth.instance;
final store = FirebaseStorage.instance;

class Auth {
  /// Signup with [email], [password], and [fullName]
  static Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    assert(email != "");
    assert(password.length >= 6);
    assert(fullName != "");
    try {
      User? user;
      await auth
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password)
          .then((value) async => {
                user = value.user!,
                await value.user!.updateDisplayName(fullName.trim()),
              });
      return user;
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

  ///log out
  static Future logout() async {
    await auth.signOut();
  }

  ///Send password reset email
  ///
  ///[email] the email of the user to reset
  ///
  static Future resetPassword({required String email}) async {
    try {
      if (email.isNotEmpty) {
        await auth.sendPasswordResetEmail(email: email.trim());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Update user details
  ///[imgPath] the image to set as the avatar
  ///
  ///[fullName] the new fullname to set
  ///
  ///[age] of the user (12 - 24 years)
  ///
  ///[classLevel] the class/grade of the learner (grade 7 - 12)
  ///
  ///[school] the school of the user
  ///
  static Future updateUser({
    required String fullName,
    required String age,
    required String school,
    required String classLevel,
    required String imgPath,
  }) async {
    // First update the profile picture
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (imgPath != "") {
      if (File(imgPath).existsSync()) {
        FirebaseStorage storage = FirebaseStorage.instance;
        UploadTask? task;
        final avatarRef = storage.ref("avatars");
        final fileName = "img-${DateTime.now().millisecondsSinceEpoch}.jpg";
        File img = File(imgPath);
        final imgRef = avatarRef.child(fileName);
        task = imgRef.putFile(img.absolute);
        final imgUrl = await (await task).ref.getDownloadURL();
        print(imgUrl);
        // update the user's display image
        await auth.currentUser?.updatePhotoURL(imgUrl);
      }
    }

    //update the other user details
    final docQuery = await db
        .collection("user_details")
        .where("userID", isEqualTo: auth.currentUser!.uid)
        .get();

    if (docQuery.docs.isNotEmpty && docQuery.size > 0) {
      //get the docID if the
      String userDocID = docQuery.docs.first.id;

      await db.collection("user_details").doc(userDocID).update({
        "fullName": fullName,
        "age": int.parse(age),
        "school": school,
        "classLevel": classLevel,
        "userID": auth.currentUser!.uid,
      });
    } else {
      //create a new user details document
      await db.collection("user_details").add({
        "fullName": fullName,
        "age": int.parse(age),
        "school": school,
        "classLevel": classLevel,
        "userID": auth.currentUser!.uid,
      });
    }
  }

  ///Get the user details
  ///
  ///Returns a [DocumentSnapshot]
  static Future<DocumentSnapshot<Map<String, dynamic>>?>
      getUserDetails() async {
    final db = FirebaseFirestore.instance;
    final docQuery = await db
        .collection("user_details")
        .where("userID", isEqualTo: auth.currentUser!.uid)
        .get();
    if (docQuery.docs.isNotEmpty && docQuery.size > 0) {
      return docQuery.docs.first;
    } else {
      return null;
    }
  }
}
