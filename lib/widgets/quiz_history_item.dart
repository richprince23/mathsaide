import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/constants/utils.dart';
import 'package:mathsaide/models/quiz_model.dart';
import 'package:resize/resize.dart';

class QuizHistoryItem extends StatelessWidget {
  const QuizHistoryItem({
    Key? key,
    required this.quiz,
  }) : super(key: key);

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    final dateTime = convertToDateTime(quiz.timestamp.toDate().toString());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.w),
      padding: pa1,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: priColDark,
            width: 2,
          ),
        ),
        color: bgColDark,
      ),
      child: ListTile(
        title: Text(
          quiz.topic,
          style: TextStyle(fontSize: 16.sp),
        ),
        subtitle:
            Text("Score : ${quiz.score} / ${quiz.totalQuestions} \n$dateTime"),
        isThreeLine: true,
        trailing: IconButton.outlined(
          color: Colors.red,
          onPressed: () {
            // deleteSession(sessionID);
          },
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
