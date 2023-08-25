import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MCQ Quiz"),
        actions: [quizOptions()],
      ),
      // body: ,
    );
  }

  Widget quizOptions() {
    return PopupMenuButton(
      itemBuilder: (context) {
        return <PopupMenuItem>[
          PopupMenuItem(
            value: "clear",
            child: const Text("Clear Messages"),
            onTap: () {
              setState(() {
                // messages = [];
              });
            },
          ),
          PopupMenuItem(
              value: "end",
              child: const Text("Quiz History"),
              onTap: () async {}),
        ];
      },
      child: const Icon(Icons.more_vert),
    );
  }
}
