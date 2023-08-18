import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/network_controller.dart';
import 'package:mathsaide/providers/page_provider.dart';
import 'package:mathsaide/providers/session_provider.dart';
import 'package:mathsaide/screens/auth/forgot_pass_screen.dart';
import 'package:mathsaide/screens/auth/login_screen.dart';
import 'package:mathsaide/screens/auth/signup_screen.dart';
import 'package:mathsaide/screens/home/home.dart';
import 'package:mathsaide/screens/settings/edit-profile.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PageProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => NetworkProvider())
      ],
      child: const MainApp(),
    ),
  );
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Resize(
      builder: () => MaterialApp(
        title: "MathsAide",
        // debugShowMaterialGrid: true,
        debugShowCheckedModeBanner: false,
        theme: myTheme.copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: const HomeScreen(),

        initialRoute: "/home",
        routes: {
          "/login": (context) => const LoginScreen(),
          "/signup": (context) => const SignUpScreen(),
          "/forgot-pass": (context) => ForgotPassScreen(),
          "/home": (context) => const HomeScreen(),
          "/edit-profile": (context) => const EditProfileScreen()
        },
      ),
    );
  }
}
