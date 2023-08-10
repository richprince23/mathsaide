import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static final mainPrefs = SharedPreferences.getInstance();

  /// Creates a new session ID and saves it into shared prefs.
  ///
  /// A session is created when a user selects a topic to practice.
  ///
  /// Generates a session ID from the current time in microseconds.
  /// [topic] is the topic selected
  ///
  /// Returns the session ID
  static Future<String> createSession(String topic) async {
    // generate session ID from random uuid
    String sessionID = DateTime.now().microsecondsSinceEpoch.toString();
    // print("Session ID: $sessionID");
    final prefs = await mainPrefs;
    // save session ID
    await prefs.setString("sessionID", sessionID);
    // save topic
    saveTopic(topic);
    return sessionID;
  }

  /// session into the shared Prefs
  static saveSession(String sessionID) async {
    final prefs = await mainPrefs;
    await prefs.setString("sessionID", sessionID);
  }

  ///Returns last session ID from shared prefs as a string
  static Future<String?> getSession() async {
    final prefs = await mainPrefs;
    // gets the topic from shared prefs
    await getTopic();
    return prefs.getString("sessionID");
  }

  ///Clears the sessionID from shared prefs
  ///
  static Future<void> clearSession() async {
    final prefs = await mainPrefs;
    // clears the topic from shared prefs
    prefs.remove("topic");
    // clears the sessionID from shared prefs
    await prefs.remove("sessionID");
  }

  /// Saves the current topic into shared prefs
  ///
  /// [topic] is the topic selected
  ///
  static saveTopic(String topic) async {
    final prefs = await mainPrefs;
    await prefs.setString("topic", topic);
  }

  ///Returns last topic from shared prefs as a string
  ///
  ///Returns null if no topic is found
  static Future<String?> getTopic() async {
    final prefs = await mainPrefs;
    // gets the topic from shared prefs
    return prefs.getString("topic");
  }
}
