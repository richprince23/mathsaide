import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:resize/resize.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  AboutScreenState createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  String _version = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _getAppInfo();
  }

  Future<void> _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'MathsAide',
              style: TextStyle(
                fontSize: 24.0.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0.h),
            Image.asset(
              'assets/images/launcher.png',
              height: 100.0.w,
              width: 100.0.w,
            ),
            SizedBox(height: 16.0.h),
            Text(
              'Version: $_version',
              style: TextStyle(
                fontSize: 18.0.sp,
              ),
            ),
            Text(
              'Build: $_buildNumber',
              style: TextStyle(
                fontSize: 18.0.sp,
              ),
            ),
            SizedBox(height: 32.0.h),
            const Text(
              'MathsAide is a mobile application aimed at helping students learn Mathematics effectively.\n\n'
              'It provides features to assist students in solving math problems through guided questioning and answering techniques.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.0.h),
            InkWell(
              child: Text(
                'Licenses of Third-Party Packages',
                style: TextStyle(
                  color: accCol,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () {
                showLicensePage(context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
