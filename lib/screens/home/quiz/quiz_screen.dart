import 'package:flutter/material.dart';
import 'package:mathsaide/providers/quiz_provider.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }


  Widget quizOptions() {
    return PopupMenuButton(
      itemBuilder: (context) {
        return <PopupMenuItem>[
          PopupMenuItem(
            value: "end",
            child: const Text("End Quiz"),
            onTap: () {
              setState(() {
                Provider.of<QuizProvider>(context, listen: false).endQuiz();
              });
            },
          ),
          PopupMenuItem(
              value: "history",
              child: const Text("Quiz History"),
              onTap: () async {}),
        ];
      },
      child: const Icon(Icons.more_vert),
    );
  }
}
