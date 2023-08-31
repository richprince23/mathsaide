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

/// Get current chat as stream
/// [sessionID] of the conversation
Stream<QuerySnapshot<Map<String, dynamic>>> getChatByID(String sessionID) {
  final results = FirebaseFirestore.instance
      .collection("sessions")
      .doc(sessionID)
      .collection("chats")
      .orderBy("timestamp", descending: false)
      .snapshots();
  return results;
}

/// Get a list of user's learning history.
/// [userID] of the logged in user
///
/// Returns a List of user's learning history
///
Stream<QuerySnapshot<Map<String, dynamic>>> getLearningHistory() {
  final history = FirebaseFirestore.instance
      .collection("sessions")
      .where('userID', isEqualTo: auth.currentUser!.uid)
      .snapshots();
  // print(history);
  return history;
}

