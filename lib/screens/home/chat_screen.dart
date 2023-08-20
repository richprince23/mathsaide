import 'package:flutter/material.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/chat_controller.dart';
import 'package:mathsaide/controllers/network_controller.dart';
import 'package:mathsaide/models/response_model.dart';
import 'package:mathsaide/providers/session_provider.dart';
import 'package:mathsaide/widgets/chat_bubble.dart';
import 'package:mathsaide/widgets/input_control.dart';
import 'package:mathsaide/widgets/loader.dart';
import 'package:mathsaide/widgets/no_network.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String initialPrompt = "";
  List messages = [];
  FocusNode focusNode = FocusNode();
  final TextEditingController txtInput = TextEditingController();
  final mathsInput = MathFieldEditingController();
  final scrollController = ScrollController();
  String prompt = '';
  String selectedTopic = "";

  @override
  void initState() {
    super.initState();
    getTopic();
  }

  Future getTopic() async {
    await context
        .read<SessionProvider>()
        .getTopic()
        .then((value) => selectedTopic = value!)
        .then((value) => {
              initialPrompt =
                  "Hello Richard, Please ask $selectedTopic question",
              setState(() {
                messages.add(
                  ChatBubble(
                    isUser: false,
                    message: initialPrompt,
                  ),
                );
              }),
            });
    chatHistory.add(ChatResponse(content: systemSolvePrompt, role: "system"));
  }

  @override
  void dispose() {
    super.dispose();
    // txtInput.dispose();
    mathsInput.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Consumer<NetworkProvider>(
        builder: (context, value, child) => value.isConnected
            ? Column(children: [
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
                SizedBox(
                  height: 10.h,
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: IconButton(
                          style: IconButton.styleFrom(
                            fixedSize: const Size(50, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                            backgroundColor: priCol,
                            foregroundColor: priColLight,
                            // padding: pa1,
                          ),
                          iconSize: 34,
                          icon: const Icon(Icons.arrow_circle_right_rounded),
                          onPressed: () async {
                            if (txtInput.text != "") {
                              setState(() {
                                messages.add(
                                  ChatBubble(
                                    isUser: true,
                                    message: txtInput.text,
                                  ),
                                );
                              });
                              showDialog(
                                barrierColor: Colors.transparent,
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => const Loader(),
                              );
                              // send message to firebase database
                              await sendChatHistory(
                                      content: txtInput.text, role: "user")
                                  .then(
                                (value) async =>
                                    // send request to backend
                                    await sendMessage(txtInput.text)
                                        .then((value) async => {
                                              print("value on front $value"),
                                              Navigator.pop(context),
                                              setState(() {
                                                messages.add(
                                                  ChatBubble(
                                                    isUser: false,
                                                    message: value,
                                                  ),
                                                );
                                              }),
                                              // send response to firebase database
                                              await sendChatHistory(
                                                  content: value,
                                                  role: "assistant"),
                                              //scroll to bottom
                                              scrollController.animateTo(
                                                scrollController
                                                    .position.maxScrollExtent,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.easeOut,
                                              ),
                                            }),
                              );
                              setState(() {
                                txtInput.text = "";
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ])
            : const NoNetwork(),
      ),
    );
  }

  void showMathsKeyboard() {
    String mathExpression = "";
    showDialog(
      context: context,
      builder: ((context) => Center(
            child: Container(
              height: 40.vh,
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
                      if (!mathsInput.isEmpty) {
                        // txtInput.text += mathsInput.currentEditingValue();
                        final parsedExpression = TeXParser(
                                mathsInput.currentEditingValue(
                                    placeholderWhenEmpty: true))
                            .parse();
                        mathExpression = "\n$parsedExpression\n";
                        print(mathExpression);
                        txtInput.text += mathExpression;
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("Insert Equation"),
                  )
                ],
              ),
            ),
          )),
    );
    // .then((_) {
    //   if (mathExpression.isNotEmpty) {
    //     setState(() {
    //       txtInput.text += mathExpression; // Update txtInput.text
    //     });
    //   }
    //   mathsInput.dispose(); // Dispose of mathsInput controller after use
    // });
  }
}
