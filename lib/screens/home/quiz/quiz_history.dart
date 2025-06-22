import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/quiz_controller.dart';
import 'package:mathsaide/models/quiz_model.dart';
import 'package:mathsaide/widgets/loader.dart';
import 'package:mathsaide/widgets/quiz_history_item.dart';
import 'package:resize/resize.dart';

class QuizHistoryScreen extends StatelessWidget {
  const QuizHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: getQuizHistory(),
        builder: (context, AsyncSnapshot snapshot) {
          // print(auth.currentUser?.uid);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline),
                  SizedBox(
                    height: 20.w,
                  ),
                  const Text("Error while loading data"),
                ],
              ),
            );
          }
          if (snapshot.data?.docs.isEmpty) {
            return Center(
              child: Container(
                padding: pa4,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: priColDark),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: bgColDark,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 50.w,
                      color: priCol,
                    ),
                    SizedBox(height: 10.w),
                    Text(
                      "No Quiz History",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.w),
                    Text(
                      "Take a quiz to see them here",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: txtColLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.w),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Go to Quizzes"),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length ?? 0,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                Quiz quiz = Quiz(
                    quizID: data["quizID"],
                    score: data["score"],
                    topic: data["topic"],
                    totalQuestions: data["noOfQuestions"],
                    timestamp: data["timestamp"]);
                return QuizHistoryItem(quiz: quiz);
              },
            );
          }
        },
      ),
    );
  }
}
