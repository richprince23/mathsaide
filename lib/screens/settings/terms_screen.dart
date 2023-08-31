import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'MathsAide Terms and Conditions',
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
              'Welcome to MathsAide, a mobile application developed by ARK Softwarez. By using our app, you agree to comply with and be bound by the following Terms and Conditions. Please read them carefully before using MathsAide.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Acceptance of Terms',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'By accessing or using MathsAide, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the app.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'User Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'You may be required to provide personal information such as your full name, age, class/grade, school name, and profile picture. This information will be used as described in our Privacy Policy.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Use of the App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'You must use MathsAide solely for educational and personal purposes.\n'
              'You may not use the app for any unlawful, unauthorized, or prohibited purposes.\n'
              'You are responsible for maintaining the security of your account and all actions taken using your account.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Content',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'MathsAide provides educational content and tools. We do not guarantee the accuracy, completeness, or usefulness of this content.\n'
              'You may not copy, reproduce, distribute, or modify any content from the app without prior written consent.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Privacy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'Your use of MathsAide is also governed by our Privacy Policy, which explains how we collect, use, and disclose personal information.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Termination',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'We reserve the right to terminate or suspend your account and access to MathsAide at our sole discretion, without prior notice or liability.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Changes to Terms and Conditions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'We may update these Terms and Conditions from time to time to reflect changes in our practices or for other operational, legal, or regulatory reasons. Any changes will be effective immediately upon posting the updated Terms and Conditions in the app.',
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
              'If you have any questions, concerns, or inquiries about these Terms and Conditions, please contact us at arksoftwarez@gmail.com.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Governing Law',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'These Terms and Conditions are governed by and construed in accordance with the laws of Ghana, without regard to its conflict of law principles.',
            ),
          ],
        ),
      ),
    );
  }
}
