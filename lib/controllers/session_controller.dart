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

// Get current chat as stream
Stream<QuerySnapshot<Map<String, dynamic>>>? getChatByID(String sessionID) {
  final results = FirebaseFirestore.instance
      .collection("sessions")
      .doc(sessionID)
      .collection("chats")
      .orderBy("timestamp", descending: false)
      .snapshots();
  return results;
}
