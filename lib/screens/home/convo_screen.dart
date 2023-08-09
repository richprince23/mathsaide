import 'package:flutter/material.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/providers/session_provider.dart';
import 'package:mathsaide/widgets/input_control.dart';
import 'package:mathsaide/widgets/session_start.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';
// import 'package:math_keyboard/math_keyboard.dart';

class ConvoScreen extends StatelessWidget {
  const ConvoScreen({
    super.key,
    required this.scrollController,
    required this.messages,
  });

  final ScrollController scrollController;
  final List messages;

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: ((context, value, child) {
        return FutureBuilder(
          future: value.getSession,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null && snapshot.data != "") {
                return buildChat(context);
              } else {
                return buildStartSession();
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: priCol,
                ),
              );
            } else {
              return buildStartSession();
            }
          },
        );
      }),
    );
  }

  Widget buildStartSession() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: px1,
          width: 100.vw,
          height: 90.vh - 60,
          child: const SessionStart(),
        ),
      ],
    );
  }

//builds a new chat screen
  Widget buildChat(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.builder(
          cacheExtent: 50.vh,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          controller: scrollController,
          scrollDirection: Axis.vertical,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return messages[index];
          },
        ),
      ),
      Container(
        padding: px1,
        // width: 94.vw,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InputControl(
                showLabel: false,
                hintText: "Enter a prompt...",
                type: TextInputType.multiline,
                suffixIcon: IconButton(
                    onPressed: () {
                      showMathsKeyboard(context);
                    },
                    icon: const Icon(Icons.calculate)),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            IconButton(
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: priCol,
                foregroundColor: priColLight,
                padding: pa1,
              ),
              icon: const Icon(Icons.send),
              onPressed: () {},
            )
          ],
        ),
      ),
    ]);
  }

  void showMathsKeyboard(BuildContext context) {
    showDialog(
      context: context,
      builder: ((context) => const Center(
            child: MathField(),
          )),
    );
  }
}
