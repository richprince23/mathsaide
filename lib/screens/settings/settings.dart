import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:mathsaide/controllers/auth_controller.dart';
import 'package:mathsaide/providers/page_provider.dart';
import 'package:mathsaide/providers/session_provider.dart';
import 'package:mathsaide/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? imgUrl;
  String name = "";
  StreamSubscription<User?>? userChangesSubscription;

  @override
  void initState() {
    super.initState();
    userChangesSubscription = auth.userChanges().listen((user) {
      if (mounted) {
        setState(() {
          imgUrl = user?.photoURL ?? "https://picsum.photos/200";
          name = user?.displayName ?? "";
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel the subscription to stop listening
    userChangesSubscription?.cancel();
    super.dispose();
  }

  /// CLears user data after Logout
  Future<void> clearUserData() async {
    Provider.of<SessionProvider>(context, listen: false).clearSession().then(
          (value) =>
              Provider.of<PageProvider>(context, listen: false).setPage(0),
        );
    await Provider.of<UserState>(context, listen: false).clearUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 15.vw,
                  backgroundColor: priCol,
                  child: CircleAvatar(
                    radius: 14.vw,
                    backgroundImage: CachedNetworkImageProvider(
                      imgUrl ?? "https://picsum.photos/200",
                      errorListener: () => const Icon(Icons.person),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                name,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                auth.currentUser!.email!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView(
                  children: [
                    const Text("Account"),
                    Container(
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: ListBody(
                        children: [
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {
                              Navigator.pushNamed(context, "/edit-profile");
                            },
                            iconColor: priCol,
                            leading: const Icon(Icons.person),
                            title: const Text("Edit Profile"),
                          ),
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {
                              Navigator.pushNamed(context, "/history");
                            },
                            iconColor: priCol,
                            leading: const Icon(Icons.work_history),
                            title: const Text("Learning History"),
                          ),
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {
                              Navigator.pushNamed(context, "/notifications");
                            },
                            iconColor: priCol,
                            leading: const Icon(Icons.notifications),
                            title: const Text("Notifications"),
                          ),
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {},
                            iconColor: priCol,
                            leading: const Icon(Icons.access_alarm_outlined),
                            title: const Text("Learning Reminders"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    const Text("Legal"),
                    Container(
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r))),
                      child: ListBody(
                        children: [
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {
                              Navigator.pushNamed(context, "/privacy");
                            },
                            iconColor: priCol,
                            leading: const Icon(Icons.privacy_tip),
                            title: const Text("Privacy Policy"),
                          ),
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {
                              Navigator.pushNamed(context, "/terms");
                            },
                            iconColor: priCol,
                            leading: const Icon(Icons.handshake_rounded),
                            title: const Text("Terms & Conditions"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    const Text("Help & Support"),
                    Container(
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r))),
                      child: ListBody(
                        children: [
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {
                              Navigator.pushNamed(context, "/about");
                            },
                            iconColor: priCol,
                            leading: const Icon(Icons.info),
                            title: const Text("About MathsAide"),
                          ),
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {
                              Navigator.pushNamed(context, "/help");
                            },
                            iconColor: priCol,
                            leading: const Icon(Icons.help),
                            title: const Text("Help & Support"),
                          ),
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {
                              Navigator.pushNamed(context, "/report-bug");
                            },
                            iconColor: priCol,
                            leading: const Icon(Icons.flag),
                            title: const Text("Report Bugs"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // const Text("Data Storage"),
                    // Container(
                    //   decoration: ShapeDecoration(
                    //     color: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10.r),
                    //     ),
                    //   ),
                    //   child: ListBody(
                    //     children: [
                    //       ListTile(
                    //         trailing:
                    //             const Icon(Icons.arrow_forward_ios, size: 14),
                    //         onTap: () {},
                    //         iconColor: priCol,
                    //         leading: const Icon(Icons.history_toggle_off),
                    //         title: const Text("Clear History"),
                    //       ),
                    //       ListTile(
                    //         trailing:
                    //             const Icon(Icons.arrow_forward_ios, size: 14),
                    //         onTap: () {},
                    //         iconColor: priCol,
                    //         leading: const Icon(Icons.memory),
                    //         title: const Text("Clear Cache"),
                    //       ),
                    //       ListTile(
                    //         trailing:
                    //             const Icon(Icons.arrow_forward_ios, size: 14),
                    //         onTap: () {},
                    //         iconColor: Colors.red,
                    //         textColor: Colors.red,
                    //         leading: const Icon(Icons.delete_sharp),
                    //         title: const Text("Delete Account"),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 10.h),
                    Container(
                      decoration: ShapeDecoration(
                        color: priCol,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: ListTile(
                        // trailing: Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () async {
                          // flow
                          // logout, clear user, clear session and reset page to 0
                          await Auth.logout().then(
                            (value) async => await clearUserData(),
                          );
                        },
                        iconColor: bgCol,
                        textColor: bgCol,
                        leading: const Icon(Icons.logout),
                        title: const Text("Logout"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
