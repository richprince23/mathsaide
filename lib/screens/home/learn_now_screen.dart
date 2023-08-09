import 'package:flutter/material.dart';
import 'package:mathsaide/providers/session_provider.dart';
import 'package:mathsaide/screens/home/convo_screen.dart';
import 'package:provider/provider.dart';

class LearnNowScreen extends StatefulWidget {
  const LearnNowScreen({super.key});

  @override
  State<LearnNowScreen> createState() => _LearnNowScreenState();
}

class _LearnNowScreenState extends State<LearnNowScreen> {
  String initialPrompt = "Hello Richard, what do you want to learn today?";
  List messages = [];
  FocusNode focusNode = FocusNode();
  final TextEditingController inputController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String prompt = '';
  String selectedSubject = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    inputController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LearnNow"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline),
          ),
          Consumer<SessionProvider>(
            builder: (context, value, child) {
              return FutureBuilder(
                  future: value.getSession,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data != "") {
                        return options();
                      } else {
                        return const SizedBox();
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox();
                    }

                    return const SizedBox();
                  });
            },
          ),
        ],
        // leading: null,
        automaticallyImplyLeading: false,
      ),
      body: ConvoScreen(scrollController: scrollController, messages: messages),
    );
  }

  //build a dropdown for the user to select an action

  Widget options() {
    return PopupMenuButton(
        itemBuilder: (context) {
          return <PopupMenuItem>[
            PopupMenuItem(
              value: "clear",
              child: const Text("Clear Messages"),
              onTap: () {
                setState(() {
                  messages = [];
                });
              },
            ),
            PopupMenuItem(
                value: "end",
                child: const Text("End Session"),
                onTap: () async {
                  context.read<SessionProvider>().clearSession();
                }),
          ];
        },
        child: const Icon(Icons.more_vert));
  }
}
