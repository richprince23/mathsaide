import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/network_controller.dart';
import 'package:mathsaide/providers/session_provider.dart';
import 'package:mathsaide/screens/home/chat_screen.dart';
import 'package:mathsaide/screens/home/start_session_screen.dart';
import 'package:provider/provider.dart';

class LearnNowScreen extends StatefulWidget {
  const LearnNowScreen({super.key});

  @override
  State<LearnNowScreen> createState() => _LearnNowScreenState();
}

class _LearnNowScreenState extends State<LearnNowScreen> {
  @override
  void initState() {
    super.initState();
    // initialize network listening stream
    connectivitySubscription =
        Provider.of<NetworkProvider>(context, listen: false)
            .connectivity
            .onConnectivityChanged
            .listen((ConnectivityResult result) {
      Provider.of<NetworkProvider>(context, listen: false)
          .updateConnectionStatus(result);
    });
    checkConnectivity();
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  void checkConnectivity() async {
    await Provider.of<NetworkProvider>(context, listen: false)
        .initConnectivity();
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
      body: Consumer<SessionProvider>(
        builder: ((context, value, child) {
          return FutureBuilder(
            future: value.getSession,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null && snapshot.data != "") {
                  return const ChatScreen();
                } else {
                  return const StartSessionScreen();
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: priCol,
                  ),
                );
              } else {
                return const StartSessionScreen();
              }
            },
          );
        }),
      ),
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
                // messages = [];
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
      child: const Icon(Icons.more_vert),
    );
  }
}
