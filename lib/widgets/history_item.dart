import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/constants/utils.dart';
import 'package:mathsaide/screens/home/view_history.dart';
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
    final dateTime = convertDateTimeStringFromTimestamp(sessionID);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ViewHistoryScreen(
              sessionID: sessionID,
              topic: topic,
            );
          }),
        );
      },
      child: Container(
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
            topic,
            style: TextStyle(fontSize: 16.sp),
          ),
          subtitle: Text(dateTime),
          // trailing: IconButton.outlined(
          //   color: Colors.red,
          //   onPressed: () async {
          //     showLoader(context);
          //     await deleteChatHistory(sessionID).then(
          //       (value) => Navigator.pop(context),
          //     );
          //   },
          //   icon: const Icon(Icons.delete),
          // ),
        ),
      ),
    );
  }
}
