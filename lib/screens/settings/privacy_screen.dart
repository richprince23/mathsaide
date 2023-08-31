import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'MathsAide Privacy Policy',
              style: TextStyle(
                fontSize: 20.0.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Effective Date: 31st August, 2023', // Replace with the actual date
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'This Privacy Policy explains how MathsAide, developed by ARK Softwarez, collects, uses, and discloses personal information when you use our mobile application.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Information We Collect',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'We may collect the following types of personal information:\n'
              '- Full Name\n'
              '- Age\n'
              '- Class/Grade\n'
              '- School Name\n'
              '- Profile Picture',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'How We Use Your Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'We use the collected information for the following purposes:\n'
              '- To personalize the learning experience within the app.\n'
              '- To provide you with a customized learning environment based on your age, grade, and educational needs.\n'
              '- To track your learning progress and provide relevant feedback.\n'
              '- To enable you to schedule learning sessions and set reminders.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Data Storage and Security',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'We take reasonable measures to protect the personal information collected through the app. However, please note that no data transmission over the internet or storage system is completely secure. While we strive to protect your personal information, we cannot guarantee its absolute security.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Information Sharing',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'We do not share any collected personal information externally. Your data remains within the MathsAide app and is used solely for the purposes mentioned in this Privacy Policy.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Your Choices',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'You can choose not to provide certain information, but this may limit your ability to use certain features of the app. You can also review, update, or delete your personal information within the app.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Contact Us',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'If you have any questions, concerns, or requests regarding your personal information or this Privacy Policy, please contact us at arksoftwarez@gmail.com.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Changes to this Privacy Policy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'We may update this Privacy Policy from time to time to reflect changes in our practices or for other operational, legal, or regulatory reasons. Any changes will be effective immediately upon posting the updated Privacy Policy in the app.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Consent',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'By using the MathsAide app, you consent to the collection, use, and disclosure of your personal information as described in this Privacy Policy.',
            ),
          ],
        ),
      ),
    );
  }
}
