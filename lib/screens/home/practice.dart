import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/chat_controller.dart';
import 'package:mathsaide/controllers/network_controller.dart';
import 'package:mathsaide/controllers/prefs.dart';
import 'package:mathsaide/models/response_model.dart';
import 'package:mathsaide/providers/page_provider.dart';
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
  // FocusNode focusNode = FocusNode();
  final mathsInput = MathFieldEditingController();
  final TextEditingController txtInput = TextEditingController();
  final scrollController = ScrollController();
  String prompt = '';
  String _sessionID = "";
  bool isStarted = false;

  String initPrompt() {
    return "You are a Mathematics Questions generator for a 12th Grade student. Generate a question for a student to practice based on $selectedTopic. Evaluate the user's answer, return a step by step approach to solve the question, without letting them know whether they are wrong or right. If user's response is not based on the question, respond with 'Please provide your solution for me to help you'. Please take your time to think to provide accurate and correct calculations in your responses. Avoid any unrelated information or verbosity. Keep your response strictly focused on the question asked. Start by providing the user with a question only";
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
    mathsInput.dispose();
    scrollController.dispose();
  }

// get session and topic for the topic and initialize chat
  void initChat() async {
    await Prefs.getSession().then(
      (value) async => {
        setState(
          () => _sessionID = value ?? "",
        ),
        await Prefs.getTopic().then(
          (topic) => setState(() => selectedTopic = topic ?? ""),
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

  //send request to the api and save the response
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
        title: Row(
          children: [
            const Text("Practice"),
            const Spacer(),
            isStarted == true
                ? OutlinedButton(
                    onPressed: () async {
                      // setState(() {
                      //   isStarted = false;
                      //   messages.clear();
                      // });
                      showLoader(context);
                      try {
                        await sendRequest("New Question").then((value) => {
                              setState(() {
                                messages.add(
                                  const ChatBubble(
                                    isUser: true,
                                    message: "Another question",
                                  ),
                                );
                              }),
                              Navigator.pop(context),
                            });
                      } catch (e) {
                        Navigator.pop(context);
                        CustomSnackBar.show(context,
                            message: "An error occur!");
                      }ed
                    },
                    // child: const Icon(Icons.add),
                    child: Text(
                      "New Question",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
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
                            if (!snapData.hasData ||
                                snapData.data?.isEmpty == true) {
                              return Center(
                                child: Container(
                                  margin: px2,
                                  padding: pa4,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: priColDark),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: bgColDark,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.history,
                                        size: 50.w,
                                        color: priCol,
                                      ),
                                      SizedBox(height: 10.w),
                                      Text(
                                        "No Active Session",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10.w),
                                      Text(
                                        "Start a new session to practise here",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: txtColLight,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10.w),
                                      ElevatedButton(
                                        onPressed: () {
                                          Provider.of<PageProvider>(context,
                                                  listen: false)
                                              .setPage(0);
                                          // Navigator.pop(context);
                                        },
                                        child:
                                            const Text("Start a new session"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
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
                                    itemCount: messages.length,
                                    itemBuilder: (context, index) {
                                      return messages[index];
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
                                    // focusNode: focusNode,
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
                                                  })
                                              .whenComplete(
                                                () =>
                                                    scrollController.animateTo(
                                                  scrollController.position
                                                          .maxScrollExtent +
                                                      // 500,
                                                      double.infinity,
                                                  curve: Curves.easeOut,
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                ),
                                              );
                                        } catch (e) {
                                          Navigator.pop(context);
                                          CustomSnackBar.show(context,
                                              message: "An error occured!");
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

//build start practice scren
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

// show maths keyboard
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
