import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/providers/quiz_provider.dart';
import 'package:mathsaide/screens/home/quiz/start_quiz_screen.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool isEnabled = true;
  bool isTapped = false;
  bool isCorrect = false;
  Color wrongCol = Colors.red.withOpacity(0.3);
  Color rightCol = Colors.green.withOpacity(0.2);
  // int correctIndex;
  void checkAnswer(bool correct) {
    setState(() {
      isTapped = true;
      isCorrect = correct;
    });
  }

  int getCorrectIndex(String correct, List<String> option) {
    return option.indexOf(correct);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [quizOptions()],
      ),
      body: Consumer<QuizProvider>(builder: (context, qz, child) {
        return qz.getIsQuizStarted
            ? Container(
                padding: pa2,
                child: Column(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      margin: py1,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(color: priCol),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: LinearProgressIndicator(
                          value: qz.getQuizIndex + 1 / qz.getNoQuestions,
                          minHeight: 20.w,
                          backgroundColor: bgWhite,
                          valueColor: AlwaysStoppedAnimation<Color>(priCol),
                        ),
                      ),
                    ),
                    Container(
                      padding: py1,
                      width: 100.vw,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            style: BorderStyle.solid,
                            width: 1,
                            color: priCol,
                          ),
                        ),
                      ),
                      child: Text(
                        "Question ${qz.quizIndex + 1} / ${qz.getNoQuestions}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: txtCol,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // build question item here

                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      padding: pa2,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        color: bgWhite,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            qz.quizQuestions[qz.quizIndex].questionText,
                            style: TextStyle(
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          ...List.generate(
                            qz.quizQuestions[qz.quizIndex].options.length,
                            (index) => InkWell(
                              onTap: isEnabled
                                  ? () {
                                      setState(() {
                                        isEnabled = false;
                                      });
                                      checkAnswer(
                                        qz.quizQuestions[qz.quizIndex]
                                                .options[index] ==
                                            qz.quizQuestions[qz.quizIndex]
                                                .correctAnswer,
                                      );
                                    }
                                  : null,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: pa2,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: priCol,
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  color: isTapped &&
                                          index ==
                                              getCorrectIndex(
                                                  qz.quizQuestions[qz.quizIndex]
                                                      .correctAnswer,
                                                  qz.quizQuestions[qz.quizIndex]
                                                      .options)
                                      ? isCorrect
                                          ? rightCol 
                                          : wrongCol
                                      : bgWhite,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      qz.quizQuestions[qz.quizIndex]
                                          .options[index],
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                    const Spacer(),
                                    Container(
                                      child: isTapped &&
                                              index ==
                                                  getCorrectIndex(
                                                    qz
                                                        .quizQuestions[
                                                            qz.quizIndex]
                                                        .correctAnswer,
                                                    qz
                                                        .quizQuestions[
                                                            qz.quizIndex]
                                                        .options,
                                                  )
                                          ? isCorrect
                                              ? const Icon(Icons.check_circle)
                                              : const Icon(Icons.cancel)
                                          : const Icon(Icons.circle_outlined),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const CreateQuizScreen();
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
