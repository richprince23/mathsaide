import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/providers/session_provider.dart';

import 'package:mathsaide/widgets/topic_options.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class StartSessionScreen extends StatelessWidget {
  const StartSessionScreen({
    super.key,
  });

  // final String username = "User";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          width: 100.vw,
          height: 80.vh,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<SessionProvider>(
                  builder: (context, value, child) {
                    return FutureBuilder(
                        future: value.getSession,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data != null && snapshot.data != "") {
                              return Column(
                                children: [
                                  FilledButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Resume last session",
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  const Text("OR"),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }

                          return const SizedBox();
                        });
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Tap on a topic to get started",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                  child: ListView(
                    children: kTopics.map((e) => TopicItem(title: e)).toList(),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
