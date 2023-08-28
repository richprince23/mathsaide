import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/chat_controller.dart';
import 'package:mathsaide/controllers/quiz_controller.dart';
import 'package:mathsaide/models/quiz_model.dart';

class QuizProvider extends ChangeNotifier {
  List noQuestions = ["5", "10", "15", "20"];
  int noOfQuestions = 10;
  String selectedTopic = "Algebra";
  int quizIndex = 0;
  List<Question> _quizQuestions = [];
  int quizScore = 0;
  bool _isQuizStarted = false;

// getters

  int get getNoQuestions => noOfQuestions;
  String get getSelectedTopic => selectedTopic;
  int get getQuizIndex => quizIndex;
  List<Question> get getQuizQuestions => _quizQuestions;
  int get getQuizScore => quizScore;
  bool get getIsQuizStarted => _isQuizStarted;

  void endQuiz() {
    _isQuizStarted = false;
    selectedTopic = "";
    noOfQuestions = 0;
    quizIndex = 0;
    notifyListeners();
  }

// setters

  Future startQuiz({required String topic, required int number}) async {
    selectedTopic = topic;
    noOfQuestions = number;

    // generate quiz questions
    setQuizQuestions(topic);
    _isQuizStarted = true;
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
        _quizQuestions = questions;
        notifyListeners();
      } else {
        print('No JSON file mapping found for topic "$selectedTopic".');
      }
    } else {
      print('Topic "$selectedTopic" is not found in the list of topics.');
    }

    List<Question> questions = [];
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    questions =
        parsed.map<Question>((json) => Question.fromJson(json)).toList();
    _quizQuestions = questions;
    notifyListeners();
    // return questions;
  }

  void nextQuestion() {
    quizIndex++;
    notifyListeners();
  }

  void increaseScore() {
    quizScore++;
    notifyListeners();
  }
}
