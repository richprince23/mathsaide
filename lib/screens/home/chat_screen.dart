import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/chat_controller.dart';
import 'package:mathsaide/controllers/network_controller.dart';
import 'package:mathsaide/controllers/prefs.dart';
import 'package:mathsaide/controllers/session_controller.dart';
import 'package:mathsaide/models/response_model.dart';
import 'package:mathsaide/widgets/chat_bubble.dart';
import 'package:mathsaide/widgets/input_control.dart';
import 'package:mathsaide/widgets/loader.dart';
import 'package:mathsaide/widgets/no_network.dart';
import 'package:mathsaide/widgets/status_snack.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

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
  String _sessionID = "";

  @override
  void initState() {
    super.initState();
    initChat();
  }

  void initChat() async {
    await Prefs.getSession().then(
      (value) async => {
        setState(
          () => _sessionID = value!,
        ),
        await Prefs.getTopic().then(
          (topic) => setState(() => selectedTopic = topic!),
        ),

        // print(_sessionID),
        chatHistory.clear(),
        if (!chatHistory
            .contains(ChatResponse(content: systemSolvePrompt, role: 'system')))
          {
            chatHistory
                .add(ChatResponse(content: systemSolvePrompt, role: 'system')),
          },
        await uploadChat(content: initialPrompt, role: "assistant"),
        chatHistory
            .add(ChatResponse(content: systemSolvePrompt, role: 'system')),
        // for (var item in chatHistory)
        //   {
        //     print(item.content),
        //   },
        Future.delayed(const Duration(microseconds: 100))
        // print(chatHistory.length),
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    txtInput.dispose();
    mathsInput.dispose();
    scrollController.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(
      builder: (context, value, child) => value.isConnected == true
          ? Column(children: [
              Expanded(
                child: FutureBuilder(
                    future: Prefs.getSession(),
                    builder: (context, snapData) {
                      if (snapData.connectionState ==
                          ConnectionState.waiting) {
                        return const Loader();
                      }
                      if (snapData.hasError) {
                        return Text("Error: ${snapData.error}");
                      }
    
                      return StreamBuilder<
                              QuerySnapshot<Map<String, dynamic>>?>(
                          // stream: getCurrentChat(),
                          stream: getChatByID(_sessionID),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Loader();
                            }
    
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
    
                            if (!snapshot.hasData ||
                                snapshot.data?.docs.isEmpty == true) {
                              return Column(
                                children: [
                                  ChatBubble(
                                      isUser: false,
                                      message:
                                          "How can i help you with $selectedTopic today?"),
                                ],
                              );
                            }
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              cacheExtent: 50.vh,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              controller: scrollController,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data?.docs.length ?? 0,
                              itemBuilder: (context, index) {
                                final data = snapshot.data?.docs[index];
                                // print("data returned is   ${data?['content']}");
                                return ChatBubble(
                                  isUser: data!["isUser"],
                                  message: data["content"],
                                );
                              },
                            );
                          });
                    }),
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
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          backgroundColor: priCol,
                          foregroundColor: priColLight,
                          // padding: pa1,
                        ),
                        iconSize: 34,
                        icon: const Icon(Icons.arrow_circle_right_rounded),
                        onPressed: () async {
                          if (txtInput.text != "") {
                            //show loading
                            showLoader(context);
                            try {
                              await sendMessage(txtInput.text)
                                  .then((value) async => {
                                        // send chat history to firestore
                                        await uploadChat(
                                                content: txtInput.text,
                                                role: "user")
                                            .then(
                                          (res) async => await uploadChat(
                                              content: value,
                                              role: "assistant"),
                                        ),
                                        Navigator.pop(context),
    
                                        SchedulerBinding.instance
                                            .addPostFrameCallback((_) {
                                          scrollController.animateTo(
                                            scrollController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                              microseconds: 100,
                                            ),
                                            curve: Curves.fastOutSlowIn,
                                          );
                                        }),
                                      });
                            } catch (e) {
                              Navigator.pop(context);
                              CustomSnackBar.show(context,
                                  message: "An error occur!");
                            }
                            setState(() {
                              txtInput.text = "";
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ])
          : const NoNetwork(),
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
                        // print(mathExpression);
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
  }
}
