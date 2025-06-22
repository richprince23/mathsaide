import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:resize/resize.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recent Notifications")),
      body: Center(
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
                Icons.notifications_off_outlined,
                size: 50.w,
                color: priCol,
              ),
              SizedBox(height: 10.w),
              Text(
                "No Recent Notifications",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.w),
              Text(
                "Your learning notifications will appear here",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: txtColLight,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.w),
              // ElevatedButton(
              //   onPressed: () {},
              //   child: const Text("Start a new session"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
