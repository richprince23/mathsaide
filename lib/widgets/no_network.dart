import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:resize/resize.dart';

class NoNetwork extends StatelessWidget {
  const NoNetwork({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: px2,
      color: bgWhite,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 50.w,
              color: priCol,
            ),
            Text(
              "No Network Connection",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Please check your internet connection",
              style: TextStyle(
                fontSize: 16.sp,
                color: txtColLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
