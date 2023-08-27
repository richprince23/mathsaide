import 'package:flutter/material.dart';
import 'package:mathsaide/models/quiz_model.dart';

class QuizProvider extends ChangeNotifier {
  List noQuestions = ["5", "10", "15", "20"];
  String noOfQuestions = "10";
  String selectedTopic = "Algebra";
  int quizIndex = 0;
  List<Question> quizQuestions = [];
  int quizScore = 0;
  bool isQuizStarted = false;

// getters

  String get getNoQuestions => noOfQuestions;
  String get getSelectedTopic => selectedTopic;
  int get getQuizIndex => quizIndex;
  List<Question> get getQuizQuestions => quizQuestions;
  int get getQuizScore => quizScore;
  bool get getIsQuizStarted => isQuizStarted;

// setters

  void startQuiz({required String topic, required String number}) {
    selectedTopic = topic;
    noOfQuestions = number;
    isQuizStarted = true;
    notifyListeners();
  }

  void setQuizQuestions(List<Question> questions) {
    quizQuestions = questions;
    notifyListeners();
  }

  void setQuizIndex(int index) {
    quizIndex = index;
    notifyListeners();
  }

  void increaseScore() {
    quizScore++;
    notifyListeners();
  }
}
