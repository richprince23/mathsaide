import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correct_answer'],
    );
  }
}

class Quiz {
  final String topic;
  final String quizID;
  final int score;
  final int totalQuestions;
  final Timestamp timestamp;

  Quiz({
    required this.topic,
    required this.quizID,
    required this.score,
    required this.totalQuestions,
    required this.timestamp,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      topic: json['topic'],
      quizID: json["quizID"],
      score: json["score"],
      totalQuestions: json["noOfQuestions"],
      timestamp: json["timestamp"],
    );
  }
}
