import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/models/quiz_model.dart';
import 'package:mathsaide/providers/quiz_provider.dart';
import 'package:mathsaide/screens/home/quiz_item.dart';
import 'package:mathsaide/widgets/select_control1.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List noQuestions = ["5", "10", "15", "20"];
  String selectedNoQuestions = "10";
  String selectedTopic = "Algebra";
  bool isQuizStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MCQ Quiz"),
      ),
      body: Container(
        padding: px2,
        child: context.read<QuizProvider>().getIsQuizStarted == false
            ? setQuiz()
            : startQuiz(),
      ),
    );
  }

  Widget setQuiz() {
    return Center(
      child: Container(
        padding: pa2,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
              side: BorderSide(color: priCol)),
          // color: accCol,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectControl(
                onChanged: (topic) {
                  selectedTopic = topic!;
                },
                initialValue: "Algebra",
                hintText: "Select a topic",
                items: kTopics
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
              ),
              SelectControl(
                initialValue: "10",
                onChanged: (number) {
                  selectedNoQuestions = number!;
                },
                items: noQuestions
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                hintText: "Number of questions",
              ),
              SizedBox(
                height: 20.w,
              ),
              SizedBox(
                width: 100.vw,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Provider.of<QuizProvider>(context, listen: false)
                          .startQuiz(
                        topic: selectedTopic,
                        number: selectedNoQuestions,
                      );
                    });
                  },
                  child: const Text("Start Quiz"),
                ),
              ),
            ]),
      ),
    );
  }

  Widget startQuiz() {
    return QuizItem(
      quizItem: Question(
          questionText: "What is 2+2",
          options: ["4", "5", "6", "7"],
          correctOptionIndex: 0),
    );
  }

  // generate quiz questions
  
}
