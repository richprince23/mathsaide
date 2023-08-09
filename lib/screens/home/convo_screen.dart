import 'package:flutter/material.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/chat_controller.dart';
import 'package:mathsaide/providers/session_provider.dart';
import 'package:mathsaide/widgets/input_control.dart';
import 'package:mathsaide/widgets/session_start.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';
// import 'package:math_keyboard/math_keyboard.dart';

class ConvoScreen extends StatefulWidget {
  ConvoScreen({
    super.key,
    required this.scrollController,
    required this.messages,
  });

  final ScrollController scrollController;
  final List messages;

  @override
  State<ConvoScreen> createState() => _ConvoScreenState();
}

class _ConvoScreenState extends State<ConvoScreen> {
  final txtInput = TextEditingController();

  final mathsInput = MathFieldEditingController();

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
          controller: widget.scrollController,
          scrollDirection: Axis.vertical,
          itemCount: widget.messages.length,
          itemBuilder: (context, index) {
            return widget.messages[index];
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
                controller: txtInput,
                suffixIcon: IconButton(
                  onPressed: () {
                    showMathsKeyboard(context);
                  },
                  icon: const Icon(Icons.calculate),
                  color: txtCol,
                ),
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
              onPressed: () async {
                if (txtInput.text != "") {
                  await sendMessage(txtInput.text);
                  setState(() {
                    txtInput.text = "";
                  });
                }
              },
            )
          ],
        ),
      ),
    ]);
  }

  void showMathsKeyboard(BuildContext context) {
    showDialog(
      context: context,
      builder: ((context) => Center(
            child: Container(
              height: 60.vh,
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.all(20.0),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                color: bgCol,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Input equation here..."),
                  SizedBox(
                    height: 20.h,
                  ),
                  MathField(
                    controller: mathsInput,
                    keyboardType: MathKeyboardType.expression,
                    variables: const ['a', 'b', 'c', 'x', 'y', 'z'],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final mathExpression =
                          TeXParser(mathsInput.currentEditingValue()).parse();
                      setState(() {
                        txtInput.text +=
                            // "\n${mathsInput.currentEditingValue()}\n\n";
                            "\n$mathExpression\n";
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Insert Equation"),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
