import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/auth_controller.dart';
import 'package:mathsaide/widgets/input_control.dart';
import 'package:mathsaide/widgets/loader.dart';
import 'package:mathsaide/widgets/status_snack.dart';
import 'package:resize/resize.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showPass = false;
  final _fnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _signupKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: KeyboardDismissOnTap(
        child: Container(
          padding: px4,
          height: 100.vh,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _signupKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   width: 30.vw,
                    //   height: 30.vw,
                    //   child: Image.asset('assets/images/launcher.png'),
                    // ),
                    Text(
                      'MathsAide',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Create a new account',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20.w),
                    InputControl(
                      controller: _fnameController,
                      type: TextInputType.name,
                      hintText: "Fullname",
                      leading: const Icon(
                        Icons.person,
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 3) {
                          return "Fullname too short";
                        }
                        return null;
                      },
                    ),
                    InputControl(
                      controller: _emailController,
                      type: TextInputType.emailAddress,
                      hintText: "Email Address",
                      leading: const Icon(
                        Icons.email,
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'\S+@\S+\.\S+', caseSensitive: false)
                                .hasMatch(value)) {
                          return "Invalid email address";
                        }
                        return null;
                      },
                    ),
                    InputControl(
                      controller: _passController,
                      type: TextInputType.visiblePassword,
                      hintText: "Password",
                      isPassword: true,
                      leading: const Icon(
                        Icons.lock,
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.toString().length < 6) {
                          return "Password must be 6 or more characters";
                        }
                        return null;
                      },
                    ),
                    InputControl(
                      type: TextInputType.visiblePassword,
                      hintText: "Confirm Password",
                      isPassword: true,
                      leading: const Icon(
                        Icons.lock,
                      ),
                      validator: (value) {
                        if (value != _passController.text) {
                          return "Passwords do not match!";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 12.w,
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_signupKey.currentState!.validate()) {
                            return;
                          }
                          showLoader(context);
                          try {
                            await Auth.signUp(
                                    email: _emailController.text,
                                    password: _passController.text,
                                    fullName: _fnameController.text)
                                .then((value) => null);
                          } on FirebaseAuthException catch (e) {
                            CustomSnackBar.show(
                              context,
                              message: e.message!,
                            );
                          } catch (e) {
                            CustomSnackBar.show(
                              context,
                              message: "An error occured. Please try again",
                            );
                          } finally {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Create Account'),
                      ),
                    ),
                    SizedBox(
                      height: 8.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 30.vw,
                          height: 2,
                          child: Container(color: priColDark),
                        ),
                        const Text("or"),
                        SizedBox(
                          width: 30.vw,
                          height: 2,
                          child: Container(color: priColDark),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.w,
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              "assets/images/google.png",
                              width: 30,
                              height: 30,
                            ),
                            const Text(
                              'Continue with Google',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
