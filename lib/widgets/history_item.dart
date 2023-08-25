import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    Key? key,
    required this.sessionID,
    required this.topic,
  }) : super(key: key);

  final String topic;
  final int sessionID;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: pa1,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: priCol,
            width: 2,
          ),
        ),
        color: accCol,
      ),
      child: ListTile(
        title: Text(topic),
        subtitle: Text(
          DateTime.fromMicrosecondsSinceEpoch(sessionID).toLocal().toString(),
        ),
      ),
    );
  }
}
