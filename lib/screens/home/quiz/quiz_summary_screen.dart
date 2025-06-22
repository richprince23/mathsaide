import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/providers/quiz_provider.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class QuizSummaryScreen extends StatelessWidget {
  const QuizSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<QuizProvider>(builder: (context, qz, child) {
        double percent = qz.getQuizScore / qz.getNoQuestions * 100;
        return Container(
          padding: pa4,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                percent >= 80
                    ? Image.asset(
                        "assets/images/stars3.png",
                        height: 100,
                      )
                    : (percent < 80 && percent >= 60)
                        ? Image.asset(
                            "assets/images/stars2.png",
                            height: 100,
                          )
                        : (percent >= 40 && percent < 60)
                            ? Image.asset(
                                "assets/images/stars1.png",
                                height: 100,
                              )
                            : Text(
                                "Better luck next time!",
                                style: GoogleFonts.alegreya(fontSize: 22.sp),
                              ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "$percent %",
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  padding: pa3,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: BorderSide(color: priCol, width: 2),
                    ),
                    color: bgWhite,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${qz.getSelectedTopic} Quiz",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      Divider(color: priCol),
                      Row(
                        children: [
                          Text(
                            "No. of Questions ",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          const Spacer(),
                          Text(
                            qz.getNoQuestions.toString(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: priCol),
                      Row(
                        children: [
                          Text(
                            "Score ",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          const Spacer(),
                          Text(
                            qz.getQuizScore.toString(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: priCol),
                      Row(
                        children: [
                          Text(
                            "Incorrect + Skipped ",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          const Spacer(),
                          Text(
                            "${qz.getNoQuestions - qz.getQuizScore}",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  width: 100.vw,
                  child: ElevatedButton(
                    onPressed: () async {
                      showLoader(context);
                      qz.endQuiz().then(
                            (value) => Navigator.pop(context),
                          );
                      // Navigator.pop(context);
                    },
                    child: const Text("Done"),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
