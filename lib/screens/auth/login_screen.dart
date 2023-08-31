import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/auth_controller.dart';
import 'package:mathsaide/widgets/input_control.dart';
import 'package:mathsaide/widgets/status_snack.dart';
import 'package:resize/resize.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPass = false;

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: KeyboardDismissOnTap(
        child: Container(
          padding: px4,
          height: 100.vh,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _loginKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30.vw,
                      height: 30.vw,
                      child: Image.asset('assets/images/launcher.png'),
                    ),
                    Text(
                      'MathsAide',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Login to your account',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20.w),
                    InputControl(
                      controller: _emailController,
                      type: TextInputType.emailAddress,
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
                    InputControl(
                      controller: _passController,
                      type: TextInputType.visiblePassword,
                      hintText: "Password",
                      leading: const Icon(Icons.lock),
                      isPassword: true,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 3) {
                          return "Password too short";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5.w),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/forgot-pass");
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(color: Colors.blue, fontSize: 14.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.w),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_loginKey.currentState!.validate()) {
                            return;
                          }
                          //show loading dialog
                          showLoader(context);
                          try {
                            await Auth.login(
                                email: _emailController.text,
                                password: _passController.text);
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
                          // Navigator.pushReplacementNamed(context, "/home");
                        },
                        child: const Text('Login'),
                      ),
                    ),
                    SizedBox(height: 20.w),
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
                      height: 20.w,
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: OutlinedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, "/signup"),
                        child: const Text(
                          'Create Account',
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
