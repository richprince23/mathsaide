import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/auth_controller.dart';
import 'package:mathsaide/controllers/quiz_controller.dart';
import 'package:mathsaide/models/quiz_model.dart';

class QuizProvider extends ChangeNotifier {
  // List noQuestions = ["5", "10", "15", "20"];
  int _noOfQuestions = 10;
  String selectedTopic = "Algebra";
  int quizIndex = 0;
  List<Question> quizQuestions = [];
  int _quizScore = 0;
  bool _isQuizStarted = false;
  String quizId = "";

// getters

  int get getNoQuestions => _noOfQuestions;
  String get getSelectedTopic => selectedTopic;
  int get getQuizIndex => quizIndex;
  List<Question> get getQuizQuestions => quizQuestions;
  int get getQuizScore => _quizScore;
  bool get getIsQuizStarted => _isQuizStarted;

//end quiz and upload to firebase
  Future endQuiz() async {
    //upload quiz
    await uploadQuiz(quizId);
    // reset quiz
    Future.delayed(const Duration(seconds: 2));
    _isQuizStarted = false;
    selectedTopic = "";
    _noOfQuestions = 0;
    _quizScore = 0;
    quizIndex = 0;
    notifyListeners();
  }

// Upload quiz to firebase
  Future uploadQuiz(String quizID) async {
    // upload quiz to firebase
    // upload quiz id to user's quiz list
    final quiz = await db.collection("quiz_grades").doc(quizID).get();
    if (!quiz.exists) {
      await db.collection("quiz_grades").doc(quizID).set({
        "quizID": quizID,
        "userID": auth.currentUser!.uid,
        "topic": selectedTopic,
        "score": _quizScore,
        "noOfQuestions": _noOfQuestions,
        "timestamp": DateTime.now(),
      });
    }
  }
// setters

  Future startQuiz({required String topic, required int number}) async {
    selectedTopic = topic;
    _noOfQuestions = number;
    _quizScore = 0;
    // generate quiz id
    quizId = generateRandomString();
    // generate quiz questions
    setQuizQuestions(topic);

    notifyListeners();
  }

  Future setQuizQuestions(String json) async {
    Map<String, String> topicToFileMapping =
        Map.fromIterables(kTopics, kTopicFiles);

    if (kTopics.contains(selectedTopic)) {
      String fileName = topicToFileMapping[selectedTopic] ?? '';
      if (fileName.isNotEmpty && fileName != "") {
        debugPrint('JSON file for "$selectedTopic" is: $fileName');

        String json = await rootBundle.loadString('assets/data/$fileName');

        List<Question> questions = [];
        final parsed = jsonDecode(json).cast<Map<String, dynamic>>();

        //get questions from json file
        questions =
            parsed.map<Question>((json) => Question.fromJson(json)).toList();
        // Shuffle the list to randomize the order of questions
        questions.shuffle();

        // Take only the desired number of questions based on _noOfQuestions
        quizQuestions = questions.take(_noOfQuestions).toList();
        // quizQuestions = questions;
        _isQuizStarted = true;
        notifyListeners();
      } else {
        debugPrint('No JSON file mapping found for topic "$selectedTopic".');
      }
    } else {
      debugPrint('Topic "$selectedTopic" is not found in the list of topics.');
    }
  }

  void nextQuestion() {
    quizIndex++;
    notifyListeners();
  }

  void increaseScore() {
    _quizScore++;
    notifyListeners();
  }
}
