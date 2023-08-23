import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathsaide/controllers/auth_controller.dart';
import 'package:mathsaide/controllers/prefs.dart';

/// Get all sessions from the database as a stream that matches the user ID and topic

/// [topic] is the topic of the session
///
Stream<QuerySnapshot<Map<String, dynamic>>> getUserSessionsByTopic(
    String topic) {
  final sessionDB = FirebaseFirestore.instance
      .collection("sessions")
      .doc(auth.currentUser!.uid)
      .collection("chats");

  return sessionDB.where("topic", isEqualTo: topic).snapshots();
}

/// Get all sessions from the database as a stream that matches the sessionID and topic
/// [sessionID] is the session ID
///

Stream<QuerySnapshot<Map<String, dynamic>>> getSessionsBySessionID(
    String sessionID) {
  final db = FirebaseFirestore.instance;

  return db
      .collection("sessions")
      .where("sessionID", isEqualTo: sessionID)
      .snapshots();
}

// Get all chats from the database as a stream that matches the sessionID
Stream<QuerySnapshot<Map<String, dynamic>>?> getCurrentChat() {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference sessionsCollection =
      firestore.collection('sessions');
  // String sessionID = "";
  var results;

  Prefs.getSession().then((sessionID) async {
    // sessionID = value!;
    await Prefs.getTopic().then((value) async {
      // topic = value;
      // Query sessions by the provided sessionID
      QuerySnapshot sessionQuery = await sessionsCollection
          .where('sessionID', isEqualTo: sessionID)
          .get();
      // print("")
      if (sessionQuery.docs.isNotEmpty && sessionQuery.size > 0) {
        // Session document with provided sessionID exists, add chat to subcollection
        String sessionDocID = sessionQuery.docs.first.id;
        results = sessionsCollection
            .doc(sessionDocID)
            .collection('chats')
            .snapshots();
      }
    });
  });
  return results;
}
