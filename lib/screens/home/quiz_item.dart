import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/models/quiz_model.dart';
import 'package:resize/resize.dart';

class QuizItem extends StatefulWidget {
  final Question quizItem;

  const QuizItem({super.key, required this.quizItem});

  @override
  State<QuizItem> createState() => _QuizItemState();
}

class _QuizItemState extends State<QuizItem> {
  int selectedOption = -1;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: pa2,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: BorderSide(color: priCol),
        ),
        color: bgWhite,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.quizItem.questionText),
            SizedBox(
              height: 10.h,
            ),
            ...widget.quizItem.options
                .map(
                  (e) => RadioListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    selectedTileColor: accCol,
                    value: e,
                    groupValue: widget.quizItem.options.indexOf(e),
                    onChanged: (intvalue) {
                      setState(() {
                        selectedOption = int.parse(e);
                      });
                    },
                    title: Text(e),
                  ),
                )
                .toList(),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              width: 100.vw,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Submit"),
              ),
            ),
          ]),
    );
  }
}
