import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/providers/quiz_provider.dart';
import 'package:provider/provider.dart';

class MainQuizScreen extends StatefulWidget {
  const MainQuizScreen({super.key});

  @override
  State<MainQuizScreen> createState() => _MainQuizScreenState();
}

class _MainQuizScreenState extends State<MainQuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<QuizProvider>().selectedTopic),
        // actions: [quizOptions()],
      ),
      body: Consumer<QuizProvider>(builder: (context, value, child) {
        return Container(
          padding: px2,
          child: Column(
            children: [
              LinearProgressIndicator(
                value: value.quizIndex / int.parse(value.getNoQuestions),
              ),
            ],
          ),
        );
      }),
    );
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
                // messages = [];
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
