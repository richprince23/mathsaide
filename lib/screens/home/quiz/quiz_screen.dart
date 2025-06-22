import 'package:easy_latex/easy_latex.dart';
import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/providers/quiz_provider.dart';
import 'package:mathsaide/screens/home/quiz/quiz_summary_screen.dart';
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
  Color wrongCol = Colors.red.withAlpha(75);
  Color rightCol = Colors.green.withAlpha(55);

  List<bool> isCorrectList = [false, false, false, false];
  List<bool> isTappedList = [false, false, false, false];
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
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   actions: [quizOptions()],
      // ),
      body: Consumer<QuizProvider>(
        builder: (context, qz, child) {
          return qz.getIsQuizStarted
              ? qz.quizIndex != qz.getNoQuestions
                  ? SafeArea(
                    child: Container(
                      padding: pa2,
                      child: Column(
                        children: [
                          Text(
                            "${qz.getSelectedTopic} Quiz",
                            style: TextStyle(fontSize: 16.sp),
                          ),

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
                                value: (qz.quizIndex + 1) / qz.getNoQuestions,
                                minHeight: 20.w,
                                backgroundColor: bgWhite,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  priCol,
                                ),
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
                              "Question ${qz.quizIndex < qz.getNoQuestions ? qz.quizIndex + 1 : qz.getNoQuestions} / ${qz.getNoQuestions}",
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
                                // Text(
                                //   qz.quizQuestions[qz.quizIndex].questionText,
                                //   style: TextStyle(fontSize: 15.sp),
                                // ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Latex(
                                    textAlign: MultiLineTextAlign.left,
                                    qz.quizQuestions[qz.quizIndex].questionText,
                                    wrapMode: LatexWrapMode.smart,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                ...List.generate(
                                  qz.quizQuestions[qz.quizIndex].options.length,
                                  (index) => InkWell(
                                    onTap:
                                        isEnabled
                                            ? () {
                                              setState(() {
                                                isEnabled = false;
                                                isTappedList[index] = true;

                                                if (qz
                                                        .quizQuestions[qz
                                                            .quizIndex]
                                                        .options[index] ==
                                                    qz
                                                        .quizQuestions[qz
                                                            .quizIndex]
                                                        .correctAnswer) {
                                                  isCorrectList[index] = true;
                                                  // increase score
                                                  qz.increaseScore();
                                                } else {
                                                  isCorrectList[index] = false;
                                                }
                                              });
                                            }
                                            : null,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      padding: pa1,
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: priCol),
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                        color:
                                            isTappedList[index]
                                                ? isCorrectList[index]
                                                    ? rightCol
                                                    : wrongCol
                                                : bgWhite,
                                      ),
                                      child: Row(
                                        children: [
                                          // Text(
                                          //   qz
                                          //       .quizQuestions[qz.quizIndex]
                                          //       .options[index],
                                          //   style: TextStyle(fontSize: 16.sp),
                                          // ),
                                          
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Latex(
                                              textAlign:
                                                  MultiLineTextAlign.left,
                                              qz
                                                  .quizQuestions[qz.quizIndex]
                                                  .options[index],
                                              wrapMode: LatexWrapMode.smart,
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            child:
                                                isTappedList[index]
                                                    ? isCorrectList[index]
                                                        ? const Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green,
                                                        )
                                                        : const Icon(
                                                          Icons.cancel,
                                                          color: Colors.red,
                                                        )
                                                    : Icon(
                                                      Icons.circle_outlined,
                                                      color: txtColLight,
                                                    ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                SizedBox(
                                  width: 100.vw,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isEnabled = true;
                                        isTapped = false;
                                        isCorrect = false;
                                        isCorrectList = [
                                          false,
                                          false,
                                          false,
                                          false,
                                        ];
                                        isTappedList = [
                                          false,
                                          false,
                                          false,
                                          false,
                                        ];
                                      });
                                      if (qz.quizIndex < qz.getNoQuestions) {
                                        qz.nextQuestion();
                                      }
                                    },
                                    child: Text(
                                      qz.quizIndex + 1 < qz.getNoQuestions
                                          ? "Next"
                                          : "Finish",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),
                          OutlinedButton(
                            onPressed: () {
                              qz.endQuiz();
                            },
                            child: const Text("End Quiz"),
                          ),
                        ],
                      ),
                    ),
                  )
                  : const QuizSummaryScreen()
              : const CreateQuizScreen();
        },
      ),
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
            onTap: () async {},
          ),
        ];
      },
      child: const Icon(Icons.more_vert),
    );
  }
}
