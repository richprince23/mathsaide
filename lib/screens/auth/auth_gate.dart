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
    auth.idTokenChanges().listen((event) async {
      print("token changed");
      await auth.currentUser?.getIdTokenResult().then((value) {
        print("new token ${value.token}");
      });
    });
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          isLoggedIn = true;
          user = user;
          Provider.of<UserState>(context, listen: false).user = user!;
        });
        // You can check the token expiration here and regenerate if needed.
        checkTokenExpiration(user!);
      } else {
        auth.currentUser?.getIdTokenResult().then((value) {
          // print("token ${value.token}");
        });
        setState(() {
          isLoggedIn = false;
          user = null;
          Provider.of<UserState>(context, listen: false).clearUser();
        });
      }
    });
  }

  Future<void> checkTokenExpiration(User user) async {
    final idTokenResult = await user.getIdTokenResult(true);
    final tokenExpirationTime = idTokenResult.expirationTime;

    final currentTime = DateTime.now();
    // Define a threshold for token expiration, e.g., 5 minutes before it expires
    final tokenThreshold = currentTime.add(const Duration(minutes: 5));

    if (tokenExpirationTime!.isBefore(tokenThreshold)) {
      // Token is about to expire, regenerate it
      await regenerateAuthTokens(user);
    }
  }

  Future<void> regenerateAuthTokens(User user) async {
    await user.getIdToken();
    user.refreshToken;
    print('Auth tokens regenerated successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.userChanges(),
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
          auth.currentUser?.getIdTokenResult().then((value) {
            print("token ${value.token}");
          });
          return const LoginScreen();
        }
      }),
    );
  }
}
