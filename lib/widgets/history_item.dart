import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/session_controller.dart';
import 'package:resize/resize.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    Key? key,
    required this.sessionID,
    required this.topic,
  }) : super(key: key);

  final String topic;
  final String sessionID;

  @override
  Widget build(BuildContext context) {
    final dateTime = convertDateTimeString(sessionID);
    return Container(
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
          topic,
          style: TextStyle(fontSize: 16.sp),
        ),
        subtitle: Text(dateTime),
      ),
    );
  }
}
