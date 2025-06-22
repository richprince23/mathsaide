import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/providers/page_provider.dart';
import 'package:mathsaide/widgets/bottom_nav.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PageProvider>(
        builder: (context, value, child) {
          return homePages[value.pageIndex];
        },
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
