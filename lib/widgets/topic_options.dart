import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/providers/session_provider.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class TopicItem extends StatelessWidget {
  const TopicItem({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<SessionProvider>().createSession(title);
      },
      child: Card(
        elevation: 0.1,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.symmetric(vertical: 2.w),
        child: Container(
          width: 90.vw,
          // color: Colors.white,
          padding: pa1.copyWith(left: 20.w),
          child: Text(
            title,
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      ),
    );
  }
}
