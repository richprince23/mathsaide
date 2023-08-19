import 'package:flutter/material.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:resize/resize.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                    // TODO :replace with CachedNetworkImage
                    backgroundImage:
                        const AssetImage("assets/images/launcher.png"),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              const Text("Theophilus Erskine"),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView(
                  children: [
                    const Text("Account"),
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
                              Navigator.pushNamed(context, "/edit-profile");
                            },
                            iconColor: priCol,
                            leading: const Icon(Icons.person),
                            title: const Text("Edit Profile"),
                          ),
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {},
                            iconColor: priCol,
                            leading: const Icon(Icons.notifications),
                            title: const Text("Notifications"),
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
                            onTap: () {},
                            iconColor: priCol,
                            leading: const Icon(Icons.privacy_tip),
                            title: const Text("Privacy Policy"),
                          ),
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {},
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
                            onTap: () {},
                            iconColor: priCol,
                            leading: const Icon(Icons.help),
                            title: const Text("Help & Support"),
                          ),
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {},
                            iconColor: priCol,
                            leading: const Icon(Icons.flag),
                            title: const Text("Report Bugs"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    const Text("Data Storage"),
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
                            onTap: () {},
                            iconColor: priCol,
                            leading: const Icon(Icons.history_toggle_off),
                            title: const Text("Clear History"),
                          ),
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {},
                            iconColor: priCol,
                            leading: const Icon(Icons.memory),
                            title: const Text("Clear Cache"),
                          ),
                          ListTile(
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {},
                            iconColor: Colors.red,
                            textColor: Colors.red,
                            leading: const Icon(Icons.delete_sharp),
                            title: const Text("Delete Account"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      decoration: ShapeDecoration(
                          color: priCol,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r))),
                      child: ListTile(
                        // trailing: Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {},
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