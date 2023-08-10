import 'package:flutter/material.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/chat_controller.dart';
import 'package:mathsaide/widgets/input_control.dart';
import 'package:resize/resize.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String initialPrompt = "Hello Richard, what do you want to learn today?";
  List messages = [];
  FocusNode focusNode = FocusNode();
  final TextEditingController txtInput = TextEditingController();
  final mathsInput = MathFieldEditingController();
  final scrollController = ScrollController();
  String prompt = '';
  String selectedSubject = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    txtInput.dispose();
    mathsInput.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                controller: txtInput,
                suffixIcon: IconButton(
                  onPressed: () {
                    showMathsKeyboard();
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

  void showMathsKeyboard() {
    String mathExpression = "";
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
                      final parsedExpression =
                          TeXParser(mathsInput.currentEditingValue()).parse();
                      mathExpression = "\n$parsedExpression\n";
                      Navigator.pop(context);
                    },
                    child: const Text("Insert Equation"),
                  )
                ],
              ),
            ),
          )),
    ).then((_) {
      if (mathExpression.isNotEmpty) {
        setState(() {
          txtInput.text += mathExpression; // Update txtInput.text
        });
      }
      mathsInput.dispose(); // Dispose of mathsInput controller after use
    });
  }
}
