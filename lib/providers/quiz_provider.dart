import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/models/quiz_model.dart';

class QuizProvider extends ChangeNotifier {
  // List noQuestions = ["5", "10", "15", "20"];
  int _noOfQuestions = 10;
  String selectedTopic = "Algebra";
  int quizIndex = 0;
  List<Question> quizQuestions = [];
  int _quizScore = 0;
  bool _isQuizStarted = false;

// getters

  int get getNoQuestions => _noOfQuestions;
  String get getSelectedTopic => selectedTopic;
  int get getQuizIndex => quizIndex;
  List<Question> get getQuizQuestions => quizQuestions;
  int get getQuizScore => _quizScore;
  bool get getIsQuizStarted => _isQuizStarted;

  void endQuiz() {
    _isQuizStarted = false;
    selectedTopic = "";
    _noOfQuestions = 0;
    _quizScore = 0;
    quizIndex = 0;
    notifyListeners();
  }

// setters

  Future startQuiz({required String topic, required int number}) async {
    selectedTopic = topic;
    _noOfQuestions = number;
    _quizScore = 0;

    // generate quiz questions
    setQuizQuestions(topic);

    notifyListeners();
  }

  Future setQuizQuestions(String json) async {
    Map<String, String> topicToFileMapping =
        Map.fromIterables(kTopics, kTopicFiles);

    if (kTopics.contains(selectedTopic)) {
      String fileName = topicToFileMapping[selectedTopic] ?? '';
      if (fileName.isNotEmpty && fileName != null) {
        print('JSON file for "$selectedTopic" is: $fileName');
        String json = await rootBundle.loadString('assets/data/$fileName');
        List<Question> questions = [];
        final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
        questions =
            parsed.map<Question>((json) => Question.fromJson(json)).toList();
        quizQuestions = questions;
        _isQuizStarted = true;
        notifyListeners();
      } else {
        print('No JSON file mapping found for topic "$selectedTopic".');
      }
    } else {
      print('Topic "$selectedTopic" is not found in the list of topics.');
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

  void checkAnswer(int selectedIndex) {
    if (selectedIndex == getQuizQuestions[getQuizIndex].correctAnswer) {
      _quizScore++;
    }
    if (quizIndex < _noOfQuestions - 1) {
      quizIndex++;
    } else {
      // Quiz completed, show results
      // You can navigate to a results screen or show a dialog here
    }
    notifyListeners();
  }
}
