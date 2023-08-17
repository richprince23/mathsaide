import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/images/loader.gif",
        width: 80.w,
        height: 80.w,
      ),
    );
  }
}
