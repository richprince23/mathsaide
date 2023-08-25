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
        child: Container(
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
                Icons.wifi_off,
                size: 50.w,
                color: priCol,
              ),
              SizedBox(height: 10.w),
              Text(
                "No Network Connection",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.w),
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
      ),
    );
  }
}
