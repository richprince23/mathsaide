import 'package:flutter/material.dart';
import 'package:mathsaide/screens/home/quiz/start_quiz_screen.dart';

class MainQuizScreen extends StatelessWidget {
  const MainQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quizzes"),
      ),
      body: const CreateQuizScreen(),
    );
  }
}
