import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/network_controller.dart';
import 'package:mathsaide/providers/session_provider.dart';
import 'package:mathsaide/screens/home/chat_screen.dart';
import 'package:mathsaide/screens/home/start_session_screen.dart';
import 'package:mathsaide/widgets/loader.dart';
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
    _initializeRemoteConfig();
    // initialize network listening stream
    checkConnectivity();
    try {
      connectivitySubscription =
          Provider.of<NetworkProvider>(context, listen: false)
              .connectivity
              .onConnectivityChanged
              .listen((ConnectivityResult result) {
        if (mounted) {
          Provider.of<NetworkProvider>(context, listen: false)
              .updateConnectionStatus(result);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    // checkConnectivity();
    // if (mounted) {
    // }
  }

  ///Initialize remote config
  Future<void> _initializeRemoteConfig() async {
    try {
      await remoteConfig.setConfigSettings(configSettings);
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  void checkConnectivity() async {
    try {
      if (mounted) {
        await Provider.of<NetworkProvider>(context, listen: false)
            .initConnectivity();
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LearnNow"),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.help_outline),
          // ),
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
        builder: (context, value, child) {
          return FutureBuilder(
            future: value.getSession,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }

              if (snapshot.hasData) {
                final sessionData = snapshot.data;

                if (sessionData != null && sessionData != "") {
                  return const ChatScreen();
                } else {
                  return const StartSessionScreen();
                }
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // Handle the case when snapshot.data is null
                return const StartSessionScreen();
              }
            },
          );
        },
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
