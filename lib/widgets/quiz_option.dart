import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:resize/resize.dart';

class QuizOption extends StatefulWidget {
  final String optionText;
  final String correctOption;
  final bool isSelected;
  final VoidCallback onTap;

  const QuizOption({
    Key? key,
    required this.optionText,
    required this.correctOption,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  State<QuizOption> createState() => QuizOptionState();
}

class QuizOptionState extends State<QuizOption> {
  final Color rightColor = Colors.green;
  final Color wrongColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: pa1,
        margin: EdgeInsets.symmetric(vertical: 5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.isSelected
                ? widget.optionText == widget.correctOption
                    ? rightColor
                    : wrongColor
                : priCol,
          ),
        ),
        child: Row(
          children: [
            Text(widget.optionText, style: TextStyle(fontSize: 16.sp)),
            const Spacer(),
            widget.isSelected
                ? widget.optionText == widget.correctOption
                    ? Icon(
                        Icons.check_circle,
                        color: rightColor,
                      )
                    : Icon(
                        Icons.cancel,
                        color: wrongColor,
                      )
                : Container(),
          ],
        ),
      ),
    );
  }
}
