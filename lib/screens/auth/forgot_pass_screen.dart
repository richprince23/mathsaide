import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/widgets/input_control.dart';
import 'package:resize/resize.dart';

class ForgotPassScreen extends StatelessWidget {
  ForgotPassScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: pa4,
          margin: px2,
          width: 100.vw,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            color: Colors.white,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enter your email address below. If you have an account with us, you'll receive an email to reset your password.",
                  maxLines: 4,
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(
                  height: 12.w,
                ),
                InputControl(
                  hintText: "Email Address",
                  leading: const Icon(Icons.email),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'\S+@\S+\.\S+', caseSensitive: false)
                            .hasMatch(value)) {
                      return "Invalid email address";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 12.w,
                ),
                SizedBox(
                  width: 100.vw,
                  child: ElevatedButton(
                    onPressed: () {
                      //TODO: Reset password logic here
                    },
                    child: const Text("Reset Password"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
