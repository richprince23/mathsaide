import 'package:flutter/material.dart';
import 'package:mathsaide/providers/quiz_provider.dart';
import 'package:mathsaide/screens/home/main_quiz_screen.dart';
import 'package:mathsaide/screens/home/start_quiz_screen.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("MCQ Quiz"),
      // ),
      body: context.watch<QuizProvider>().getIsQuizStarted == false
          ? const CreateQuizScreen()
          : const MainQuizScreen(),
    );
  }

  // generate quiz questions
}
