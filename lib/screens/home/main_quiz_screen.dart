import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/quiz_controller.dart';
import 'package:mathsaide/providers/quiz_provider.dart';
import 'package:mathsaide/widgets/quiz_item.dart';
import 'package:mathsaide/widgets/status_snack.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

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
        automaticallyImplyLeading: false,
        title: Text("${context.watch<QuizProvider>().selectedTopic} Quiz"),
        actions: [quizOptions()],
      ),
      body: Consumer<QuizProvider>(builder: (context, value, child) {
        int total = value.getNoQuestions;
        return Container(
          padding: pa2,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  minHeight: 20.w,
                  value: value.quizIndex / total,
                  valueColor: AlwaysStoppedAnimation<Color>(priCol),
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    value.getQuizQuestions.isNotEmpty
                        ? QuizItem(
                            quizItem: value.getQuizQuestions[value.quizIndex])
                        : Container(
                            child: const Text("No Questions"),
                          ),
                    // const Spacer(),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      width: 100.vw,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {});
                          var quiz = context.read<QuizProvider>().quizIndex;
                          if (quiz < total - 1) {
                            context.read<QuizProvider>().nextQuestion();
                          } else {
                            // await context.read<QuizController>().submitQuiz();
                            context.read<QuizProvider>().endQuiz();
                            CustomSnackBar.show(
                              context,
                              message: "Quiz Submitted",
                            );
                          }
                        },
                        child: const Text("Next"),
                      ),
                    ),
                  ],
                ),
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
