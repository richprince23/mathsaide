import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathsaide/screens/home/learn_now_screen.dart';
import 'package:resize/resize.dart';

//Primary colors
Color priCol = const Color(0xff26a69a);
Color priColDark = const Color(0xff408d86);
Color priColLight = const Color(0xffcdfaf6);

//accent colors
Color accCol = const Color(0xff80cbc4);
Color accColDark = const Color(0xff43a49b);

//background Colors
Color bgCol = const Color(0xffe0f2f1);
Color bgColDark = const Color(0xffd0ebea);
Color bgWhite = const Color(0xffffffff);

//text Colors
Color txtCol = const Color(0xff263339);
Color txtColLight = const Color(0xff728f9e);

ThemeData myTheme = ThemeData(
  useMaterial3: true,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: priColLight,
      foregroundColor: txtCol,
      elevation: 0,
      padding: kPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      textStyle: GoogleFonts.poppins(fontSize: 18.sp),
    ),
  ),
  //elevated button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0.1,
      backgroundColor: priColDark,
      foregroundColor: bgWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: kPadding,
      textStyle: GoogleFonts.poppins(fontSize: 18.sp),
    ),
  ),

  //outlined button theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0.1,
      backgroundColor: bgWhite,
      foregroundColor: txtCol,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(color: priColDark, width: 3),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
      textStyle: GoogleFonts.poppins(fontSize: 18.sp),
      side: BorderSide(color: priColDark, width: 1),
    ),
  ),

  //filled button theme
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      elevation: 0.1,
      backgroundColor: priColLight,
      foregroundColor: txtCol,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(color: priColDark),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
      textStyle: GoogleFonts.poppins(fontSize: 18.sp),
    ),
  ),

  //text theme
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    decoration: TextDecoration.none,
  ),
  primaryTextTheme: GoogleFonts.poppinsTextTheme().apply(
    decoration: TextDecoration.none,
  ),

  primaryColor: priCol,
  scaffoldBackgroundColor: bgCol,
  //appbar theme
  appBarTheme: AppBarTheme(
    backgroundColor: bgColDark,
    elevation: 0.1,
    iconTheme: IconThemeData(color: txtCol),
    titleTextStyle: GoogleFonts.poppins(fontSize: 18.sp, color: txtCol),
  ),

  //bottom nav theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: bgCol,
    elevation: 0,
    selectedItemColor: priCol,
    unselectedItemColor: txtColLight,
    selectedLabelStyle: GoogleFonts.poppins(fontSize: 12.sp),
    unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12.sp),
  ),

  //card theme
  cardTheme: CardTheme(
    color: bgColDark,
    elevation: 0.1,
    shadowColor: accColDark,
    surfaceTintColor: accCol,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.r),
    ),
  ),

  //input decoration
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(width: 0.5, color: priCol),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: priColDark, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 255, 117, 107),
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(width: 0.5, color: priCol),
    ),
    filled: true,
    fillColor: bgWhite,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 20.w,
      vertical: 10.w,
    ),
    hintStyle: TextStyle(
      color: txtCol.withOpacity(0.5),
      fontWeight: FontWeight.w300,
      fontSize: 16.sp,
    ),
    iconColor: priColDark,
    focusColor: priCol,
    prefixIconColor: priColDark,
  ),
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(secondary: accCol)
      .copyWith(background: bgCol)
      .copyWith(onBackground: txtCol)
      .copyWith(shadow: accColDark)
      .copyWith(onPrimaryContainer: txtCol)
      .copyWith(onSecondary: txtColLight),
);

EdgeInsets kPadding = EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w);

EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w);

//padding all
EdgeInsets pa1 = EdgeInsets.all(8.w);
EdgeInsets pa2 = EdgeInsets.all(16.w);
EdgeInsets pa3 = EdgeInsets.all(24.w);
EdgeInsets pa4 = EdgeInsets.all(32.w);

//padding w
EdgeInsets px1 = EdgeInsets.symmetric(horizontal: 8.w);
EdgeInsets px2 = EdgeInsets.symmetric(horizontal: 16.w);
EdgeInsets px3 = EdgeInsets.symmetric(horizontal: 24.w);
EdgeInsets px4 = EdgeInsets.symmetric(horizontal: 32.w);

//padding h
EdgeInsets py1 = EdgeInsets.symmetric(vertical: 8.w);
EdgeInsets py2 = EdgeInsets.symmetric(vertical: 16.w);
EdgeInsets py3 = EdgeInsets.symmetric(vertical: 24.w);
EdgeInsets py4 = EdgeInsets.symmetric(vertical: 32.w);

//Pages

const homePages = [
  LearnNowScreen(),
  LearnNowScreen(),
  LearnNowScreen(),
  LearnNowScreen(),
];

const kTopics = [
  "Trigonometry",
  "Indices, Surds, & Logarithms",
  "Vector, Bearings & Matrices",
  "Algebra",
  "Statistics & Probability",
  "Polynomials",
  "Sets & Relations",
  "Calculus",
  "Circle Theorem",
  "Series & Sequence",
  "Permutations & Combinations",
  "General Mathematics",
];
