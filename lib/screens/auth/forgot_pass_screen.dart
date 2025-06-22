import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/auth_controller.dart';
import 'package:mathsaide/widgets/input_control.dart';
import 'package:mathsaide/widgets/status_snack.dart';
import 'package:resize/resize.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final _email = TextEditingController();

  String status = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
  }

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
                Text(
                  status,
                  style: TextStyle(color: priCol),
                ),
                SizedBox(
                  height: 12.w,
                ),
                SizedBox(
                  width: 100.vw,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      showLoader(context);
                      try {
                        await Auth.resetPassword(email: _email.text).then(
                          (value) => setState(() {
                            status =
                                "Email has been sent successfully. Check your email to reset your password!";
                          }),
                        );
                      } catch (e) {
                        CustomSnackBar.show(
                          context,
                          message: "An error occured. Try again!",
                        );
                      } finally {
                        Navigator.of(context).pop();
                      }
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
