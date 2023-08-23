import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mathsaide/controllers/auth_controller.dart';
import 'package:mathsaide/providers/user_provider.dart';
import 'package:mathsaide/screens/auth/login_screen.dart';
import 'package:mathsaide/screens/home/home.dart';
import 'package:mathsaide/widgets/loader.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool isLoggedIn = false;
  User? user;

  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          isLoggedIn = true;
          user = user;
          Provider.of<UserState>(context, listen: false).user = user!;
        });
      } else {
        auth.currentUser!.getIdTokenResult().then((value) {
          print("token ${value.token}");
        });
        setState(() {
          isLoggedIn = false;
          user = null;
          Provider.of<UserState>(context, listen: false).clearUser();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        if (snapshot.data != null) {
          // if (snapshot.data!.uid.isNotEmpty) {
          print(snapshot.data!.uid);
          return const HomeScreen();
          // }
          // else {
          //   print("No user");
          //   return const LoginScreen();
          // }
        } else {
          print("No user data");
          return const LoginScreen();
        }
      }),
    );
  }
}
