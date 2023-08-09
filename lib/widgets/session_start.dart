import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/widgets/topic_options.dart';
import 'package:resize/resize.dart';

class SessionStart extends StatelessWidget {
  const SessionStart({super.key});

// TODO: Replace with actual username from firebase auth
  final String username = "Richard";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.h,
          ),
          Text(
            "Hi $username!,\nTap on a topic to get started",
            style: TextStyle(
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.h,
          ),
          Flexible(
            child: ListView(
              children: kTopics.map((e) => TopicItem(title: e)).toList(),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          const Text("OR"),
          SizedBox(
            height: 10.h,
          ),
          FilledButton(
            onPressed: () {},
            child: Text(
              "Resume last session",
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(
            height: 10.h,
          )
        ],
      ),
    );
  }
}
