import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathsaide/controllers/auth_controller.dart';

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
Stream<QuerySnapshot<Map<String, dynamic>>?> getChatsBySessionID(
    String sessionID) {
  final db = FirebaseFirestore.instance;
  //  var empty =[];
  final empty = <QuerySnapshot<Map<String, dynamic>>>[];
  return db
      .collection("sessions")
      .where("sessionID", isEqualTo: sessionID)
      .limit(1) // Since sessionID should be unique, we limit to 1 document
      .snapshots()
      .asyncMap((querySnapshot) async {
    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;
      final chatsSnapshot =
          await docSnapshot.reference.collection("chats").get();
      return chatsSnapshot;
    } else {
      return null;
    }
  });
}
