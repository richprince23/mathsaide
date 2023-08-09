import 'package:flutter/material.dart';
import 'package:mathsaide/controllers/prefs.dart';

class SessionProvider extends ChangeNotifier {
  String? _sessionID;

  ///Returns the sessionID.
  ///
  ///Checks if [sessionID] is empty or not and retun from either shared prefs or provider value
  get getSession async {
    String? sess;
    await Prefs.getSession().then((value) => sess = value!);

    // if sessionID is empty, return the provider value
    if (sess == null || sess == "") {
      sess = _sessionID;
    }
    return sess;
  }

  /// Creates a new session ID and saves it into shared prefs.
  /// A session is created when a user selects a topic to practice.

  Future createSession(String topic) async {
    // generate session ID from random uuid
    String sessionID = DateTime.now().microsecondsSinceEpoch.toString();
    // save session ID
    await Prefs.saveSession(sessionID);
    // save topic
    await Prefs.saveTopic(topic);
    _sessionID = sessionID;
    notifyListeners();
  }

  ///Saves a new sessionID into shared Prefs
  set setSession(String sessionID) {
    Prefs.saveSession(sessionID);
    _sessionID = sessionID;
    notifyListeners();
  }

  ///Clears the sessionID from shared prefs
  ///
  Future<void> clearSession() async {
    _sessionID = null;
    await Prefs.clearSession();
    notifyListeners();
  }

  ///Set current selected topic
  ///
  ///[topic] is the topic selected
  ///
  Future<void> setTopic(String topic) async {
    await Prefs.saveTopic(topic);
    print("Topic set to $topic");
    notifyListeners();
  }

  ///Returns the current topic
  ///
  ///Returns null if no topic is found
  ///
  Future<String?> getTopic() async {
    return await Prefs.getTopic();
  }
}
