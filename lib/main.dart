import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/providers/page_provider.dart';
import 'package:mathsaide/providers/session_provider.dart';
import 'package:mathsaide/screens/auth/forgot_pass_screen.dart';
import 'package:mathsaide/screens/auth/login_screen.dart';
import 'package:mathsaide/screens/auth/signup_screen.dart';
import 'package:mathsaide/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PageProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
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
          textTheme: GoogleFonts.poppinsTextTheme().copyWith(
            displayLarge: GoogleFonts.poppins(
              fontSize: 96.sp,
              fontWeight: FontWeight.w300,
              color: txtCol,
            ),
            displayMedium: GoogleFonts.poppins(
              fontSize: 60.sp,
              fontWeight: FontWeight.w300,
              color: txtCol,
            ),
            displaySmall: GoogleFonts.poppins(
              fontSize: 48.sp,
              fontWeight: FontWeight.w400,
              color: txtCol,
            ),
            headlineMedium: GoogleFonts.poppins(
              fontSize: 34.sp,
              fontWeight: FontWeight.w400,
              color: txtCol,
            ),
            headlineSmall: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.w400,
              color: txtCol,
            ),
            titleLarge: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: txtCol,
            ),
            titleMedium: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: txtCol,
            ),
            titleSmall: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: txtCol,
            ),
            bodyLarge: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: txtCol,
            ),
            bodyMedium: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: txtCol,
            ),
            labelLarge: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: txtCol,
            ),
            bodySmall: GoogleFonts.poppins(
              fontSize: 12.sp,
              letterSpacing: 0.4,
              color: txtCol,
            ),
            labelSmall: GoogleFonts.poppins(
              fontSize: 10.sp,
              color: txtCol,
            ),
          ),
        ),
        home: const HomeScreen(),

        initialRoute: "/home",
        routes: {
          "/login": (context) => const LoginScreen(),
          "/signup": (context) => const SignUpScreen(),
          "/forgot-pass": (context) => ForgotPassScreen(),
          "/home": (context) => const HomeScreen(),
        },
      ),
    );
  }
}
