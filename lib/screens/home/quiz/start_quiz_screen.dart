import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/providers/quiz_provider.dart';
import 'package:mathsaide/widgets/select_control1.dart';
import 'package:mathsaide/widgets/status_snack.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => CreateQuizScreenState();
}

class CreateQuizScreenState extends State<CreateQuizScreen> {
  List noQuestions = ["5", "10", "15", "20"];
  String selectedNoQuestions = "10";
  String selectedTopic = "Algebra";
  bool isQuizStarted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: px2,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create a New Quiz by choosing a topic and number of questions.",
              style: TextStyle(fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              padding: pa2,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(color: priCol),
                ),
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
                      onPressed: () async {
                        showLoader(context);
                        await Provider.of<QuizProvider>(context, listen: false)
                            .startQuiz(
                              topic: selectedTopic,
                              number: int.parse(selectedNoQuestions),
                            )
                            .then((value) => {
                                  Navigator.pop(context),
                                  CustomSnackBar.show(
                                    context,
                                    message: "Quiz Started",
                                  ),
                                });
                      },
                      child: const Text("Start Quiz"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/quiz-history");
              },
              child: const Text("Recent Quizzes"),
            ),
          ],
        ),
      ),
    );
  }
}
