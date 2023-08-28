import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/models/quiz_model.dart';
import 'package:mathsaide/providers/quiz_provider.dart';
import 'package:mathsaide/widgets/quiz_option.dart';
import 'package:mathsaide/widgets/status_snack.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class QuizItem extends StatefulWidget {
  final Question quizItem;

  const QuizItem({super.key, required this.quizItem});

  @override
  State<QuizItem> createState() => _QuizItemState();
}

class _QuizItemState extends State<QuizItem> {
  late List<bool> selectedStates;
  bool isOptionSelected = false; // To track if any option is selected

  bool optionsDisabled = false; // To track if options are disabled

  @override
  void initState() {
    super.initState();
    selectedStates = List.filled(widget.quizItem.options.length, false);
    isOptionSelected = false;
    optionsDisabled = false;
  }

  void _handleOptionTapped(int index) {
    if (!optionsDisabled) {
      setState(() {
        optionsDisabled = true;
        setState(() {
          for (int i = 0; i < selectedStates.length; i++) {
            if (i == index) {
              selectedStates[i] = true; // Select the tapped option
            } else {
              selectedStates[i] = false; // Deselect all other options
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant QuizItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectedStates = List.filled(widget.quizItem.options.length, false);
    optionsDisabled = false;
  }

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
          Text(widget.quizItem.questionText, style: TextStyle(fontSize: 14.sp)),
          SizedBox(
            height: 10.h,
          ),
          ...widget.quizItem.options.asMap().entries.map((entry) {
            int index = entry.key;
            String optionText = entry.value;
            bool isSelected = selectedStates[index];

            return QuizOption(
                optionText: optionText,
                correctOption: widget.quizItem.correctAnswer,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    isOptionSelected = true;
                  });
                  _handleOptionTapped(index);
                });
          }).toList(),
          SizedBox(
            height: 20.h,
          ),
          SizedBox(
            width: 100.vw,
            child: ElevatedButton(
              onPressed: () async {
                // setState(() {
                //   // selectedStates = [
                //   //   false,
                //   //   false,
                //   //   false,
                //   //   false,
                //   // ];
                // });
                var quiz = context.read<QuizProvider>().quizIndex;
                var total = context.read<QuizProvider>().getNoQuestions;
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
    );
  }
}
