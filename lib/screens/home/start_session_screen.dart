import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';

import 'package:mathsaide/widgets/topic_options.dart';
import 'package:resize/resize.dart';

class StartSessionScreen extends StatelessWidget {
  const StartSessionScreen({
    super.key,
  });

  final String username = "User";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: px1,
          width: 100.vw,
          height: 90.vh - 60,
          child: Container(
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
          ),
        ),
      ],
    );
  }
}
