import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/chat_controller.dart';
import 'package:mathsaide/controllers/network_controller.dart';
import 'package:mathsaide/controllers/prefs.dart';
import 'package:mathsaide/models/response_model.dart';
import 'package:mathsaide/widgets/chat_bubble.dart';
import 'package:mathsaide/widgets/input_control.dart';
import 'package:mathsaide/widgets/loader.dart';
import 'package:mathsaide/widgets/no_network.dart';
import 'package:mathsaide/widgets/status_snack.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  String selectedTopic = "";
  String initialPrompt = "";
  List messages = [];

  final TextEditingController txtInput = TextEditingController();
  final scrollController = ScrollController();
  String prompt = '';
  String _sessionID = "";
  bool isStarted = false;

  String initPrompt() {
    return "You are a Mathematics Questions generator for a 12th Grade student. Generate a question for a student to practice based on $selectedTopic. Evalute the user's answer and let them know if the answer is correct or incorrect. If incorrect , return a step by step approach to solve the question. Please provide a concise and accurate response. Avoid any unrelated information or verbosity. Keep your response strictly focused on the question asked. Start by providing the user with a question only";
  }

  @override
  void initState() {
    super.initState();
    initChat();
  }

  @override
  void dispose() {
    super.dispose();
    txtInput.dispose();
    scrollController.dispose();
  }

// get session and topic for the topic and initialize chat
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
        queryHistory.clear(),
        if (!queryHistory
            .contains(ChatResponse(content: initPrompt(), role: 'system')))
          {
            queryHistory
                .add(ChatResponse(content: initPrompt(), role: 'system')),
          },

        // queryHistory.add(ChatResponse(content: initPrompt(), role: 'system')),

        Future.delayed(const Duration(microseconds: 100))
      },
    );
  }

  Future sendRequest(String prompt) async {
    if (prompt == "" && prompt.isEmpty) {
      setState(() {
        messages
            .add(const ChatBubble(isUser: true, message: "Give me a question"));
      });
    } else {
      setState(() {
        messages.add(ChatBubble(isUser: true, message: prompt.trim()));
      });
    }

    await generatePracticeQuestions(prompt).then((value) => {
          setState(() {
            messages.add(
              ChatBubble(
                isUser: false,
                message: value ?? "An error occured. Please try again",
              ),
            );
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Practice"),
      ),
      body: KeyboardDismissOnTap(
        child: Consumer<NetworkProvider>(
          builder: (context, value, child) => value.isConnected == true
              ? Column(
                  children: [
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

                            return isStarted != true
                                ? startPractice(context)
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    cacheExtent: 50.vh,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    controller: scrollController,
                                    scrollDirection: Axis.vertical,
                                    itemCount: chatHistory.length - 1,
                                    itemBuilder: (context, index) {
                                      final data =
                                          // ChatResponse.fromJson(
                                          jsonDecode(
                                              chatHistory[index + 1] as String);
                                      // );
                                      // print("data returned is   ${data?['content']}");
                                      return ChatBubble(
                                        isUser:
                                            data.role == "user" ? true : false,
                                        message: data.content,
                                      );
                                    },
                                  );
                          }),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    isStarted == true
                        ? Container(
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
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      backgroundColor: priCol,
                                      foregroundColor: priColLight,
                                      // padding: pa1,
                                    ),
                                    iconSize: 34,
                                    icon: const Icon(
                                      Icons.arrow_circle_right_rounded,
                                    ),
                                    onPressed: () async {
                                      if (txtInput.text != "") {
                                        //show loading
                                        showLoader(context);
                                        try {
                                          await sendRequest(txtInput.text)
                                              .then((value) async => {
                                                    Navigator.pop(context),
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
                          )
                        : const SizedBox.shrink(),
                  ],
                )
              : const NoNetwork(),
        ),
      ),
    );
  }

  Widget startPractice(BuildContext context) {
    return Column(
      children: [
        ChatBubble(
          isUser: false,
          message:
              "Practising is a great way to master! Let's solve some $selectedTopic.",
        ),
        SizedBox(
          height: 50.h,
        ),
        isStarted != true
            ? ElevatedButton(
                onPressed: () async {
                  showLoader(context);
                  await sendRequest("").then((value) => {
                        // print(
                        //     "ressss: " + value),
                        Navigator.pop(context),
                        setState(() {
                          isStarted = true;
                        }),
                      });
                },
                child: const Text("Give me a question"),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
