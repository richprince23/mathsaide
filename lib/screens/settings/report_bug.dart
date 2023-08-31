import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mathsaide/widgets/input_control.dart';
import 'package:mathsaide/widgets/status_snack.dart';
import 'package:resize/resize.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BugReportScreen extends StatelessWidget {
  BugReportScreen({super.key});

  final _bugDescriptionController = TextEditingController();

  void _sendBugReport(BuildContext context) async {
    const emailSubject = 'Bug Report for MathsAide App';
    final emailBody = _bugDescriptionController.text;

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'arksoftwarez@gmail.com', // Replace with your developer's email
      queryParameters: {
        'subject': emailSubject,
        'body': emailBody,
      },
    );

    if (Platform.isIOS || Platform.isAndroid) {
      if (await canLaunchUrlString(emailUri.toString())) {
        await launchUrlString(emailUri.toString());
      } else {
        // ignore: use_build_context_synchronously
        CustomSnackBar.show(
          context,
          message: 'Could not open email app.',
        );
      }
    } else {
      CustomSnackBar.show(
        context,
        message: 'Bug report feature is not supported on this platform',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report a Bug'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please describe the bug:',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            InputControl(
              controller: _bugDescriptionController,
              hintText: 'Describe the bug in detail...',
              type: TextInputType.multiline,
            ),
            SizedBox(height: 16.0.h),
            ElevatedButton(
              onPressed: () => _sendBugReport(context),
              child: const Text('Send Bug Report'),
            ),
          ],
        ),
      ),
    );
  }
}
