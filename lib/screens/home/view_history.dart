import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/prefs.dart';
import 'package:mathsaide/controllers/session_controller.dart';
import 'package:mathsaide/widgets/chat_bubble.dart';
import 'package:mathsaide/widgets/loader.dart';
import 'package:resize/resize.dart';

class ViewHistoryScreen extends StatelessWidget {
  final String sessionID;
  final String topic;
  ViewHistoryScreen({super.key, required this.sessionID, required this.topic});

  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              topic,
              style: TextStyle(fontSize: 14.sp, color: txtCol),
            ),
            Text(
              convertDateTimeString(sessionID),
              style: TextStyle(fontSize: 12.sp, color: txtColLight),
            ),
          ],
        ),
      ),
      body: Container(
        padding: px1,
        child: FutureBuilder(
            future: Prefs.getSession(),
            builder: (context, snapData) {
              if (snapData.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              if (snapData.hasError) {
                return Text("Error: ${snapData.error}");
              }

              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>?>(
                  // stream: getCurrentChat(),
                  stream: getChatByID(sessionID),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData ||
                        snapshot.data?.docs.isEmpty == true) {
                      return Center(
                        child: Text(
                          "No learning data found",
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      cacheExtent: 50.vh,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        final data = snapshot.data?.docs[index];
                        // print("data returned is   ${data?['content']}");
                        return ChatBubble(
                          isUser: data!["isUser"],
                          message: data["content"],
                        );
                      },
                    );
                  });
            }),
      ),
    );
  }
}
