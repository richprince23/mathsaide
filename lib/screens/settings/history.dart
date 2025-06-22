import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/session_controller.dart';
import 'package:mathsaide/providers/page_provider.dart';
import 'package:mathsaide/widgets/history_item.dart';
import 'package:mathsaide/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learning History"),
        // automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: getLearningHistory(),
          // stream: FirebaseFirestore.instance
          //     .collection("sessions")
          //     .where('userID', isEqualTo: "sdasd")
          //     .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            // print(auth.currentUser?.uid);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline),
                    SizedBox(
                      height: 20.w,
                    ),
                    const Text("Error while loading data"),
                  ],
                ),
              );
            }
            if (snapshot.data?.docs.isEmpty) {
              return Center(
                child: Container(
                  margin: px2,
                  padding: pa4,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: priColDark),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: bgColDark,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 50.w,
                        color: priCol,
                      ),
                      SizedBox(height: 10.w),
                      Text(
                        "No Learning History",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.w),
                      Text(
                        "Start a new session to see your learning history",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: txtColLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.w),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<PageProvider>(context, listen: false)
                              .setPage(0);
                          Navigator.pop(context);
                        },
                        child: const Text("Start a new session"),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length ?? 0,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];

                  return HistoryItem(
                    topic: data["topic"],
                    sessionID: data["sessionID"],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
